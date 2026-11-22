/*
  ==============================================================================

    HumanizerEngine.h
    HatHumanizer - Real-Time Audio Randomizer with Pitch Variation & Dual-Tap Delay

  ==============================================================================
*/

#pragma once

#include <JuceHeader.h>
#include <vector>
#include <cmath>
#include <algorithm>

class HumanizerEngine
{
public:
    HumanizerEngine()
    {
        bufferL.resize(bufferSize, 0.0f);
        bufferR.resize(bufferSize, 0.0f);
    }

    void prepare(double newSampleRate)
    {
        sampleRate = (newSampleRate > 0.0) ? newSampleRate : 44100.0;
        reset();

        // 4 ms crossfade window between hits: completely click-free and seamless
        crossfadeLength = std::max(8, static_cast<int>(0.004 * sampleRate));

        // Pitch rate relaxation factor (~45 ms half-life)
        rateDecayFactor = 1.0f - std::exp(-1.0f / (0.045f * static_cast<float>(sampleRate)));
    }

    void reset()
    {
        std::fill(bufferL.begin(), bufferL.end(), 0.0f);
        std::fill(bufferR.begin(), bufferR.end(), 0.0f);
        writeIndex = 0;

        for (int i = 0; i < 2; ++i)
        {
            taps[i].delaySamples = 0.0f;
            taps[i].readOffset = 0.0f;
            taps[i].playbackRate = 1.0f;
            taps[i].gain = 1.0f;
            taps[i].panL = 1.0f;
            taps[i].panR = 1.0f;
        }

        activeTap = 0;
        isCrossfading = false;
        crossfadeCount = 0;
    }

    struct HitVariation
    {
        float timingShiftMs = 0.0f;
        float gainDb = 0.0f;
        float pan = 0.0f;
        float pitchCents = 0.0f;
    };

    // Called when the TransientDetector detects a new hi-hat hit
    HitVariation triggerHit(float maxTimingShiftMs, float maxGainVarDb, float maxPanVarPercent, float maxPitchVarCents, float amountPercent)
    {
        const float amt = juce::jlimit(0.0f, 1.0f, amountPercent * 0.01f);

        // 1. Alternate active tap to allow smooth, artifact-free crossfading
        const int nextTap = 1 - activeTap;

        // 2. Micro-timing shift (0 ms to maxTimingShiftMs) + safety base margin
        const float baseDelaySamples = 0.0035f * static_cast<float>(sampleRate); // 3.5 ms safe lookback
        const float randomShiftMs = random.nextFloat() * maxTimingShiftMs * amt;
        const float delayInSamples = baseDelaySamples + (randomShiftMs * 0.001f * static_cast<float>(sampleRate));

        // 3. Subtle Gain / Volume variation (+/- maxGainVarDb)
        const float randomGainDb = (random.nextFloat() * 2.0f - 1.0f) * maxGainVarDb * amt;
        const float linearGain = juce::Decibels::decibelsToGain(randomGainDb);

        // 4. Stereo Pan variation (+/- maxPanVarPercent)
        const float randomPan = (random.nextFloat() * 2.0f - 1.0f) * (maxPanVarPercent * 0.01f) * amt;
        const float clampedPan = juce::jlimit(-1.0f, 1.0f, randomPan);
        const float panL = std::min(1.0f, 1.0f - clampedPan);
        const float panR = std::min(1.0f, 1.0f + clampedPan);

        // 5. Pitch Variation (+/- maxPitchVarCents)
        const float randomPitchCents = (random.nextFloat() * 2.0f - 1.0f) * maxPitchVarCents * amt;
        const float initialRate = std::pow(2.0f, randomPitchCents / 1200.0f);

        // Configure next tap
        taps[nextTap].delaySamples = delayInSamples;
        taps[nextTap].readOffset = delayInSamples;
        taps[nextTap].playbackRate = initialRate;
        taps[nextTap].gain = linearGain;
        taps[nextTap].panL = panL;
        taps[nextTap].panR = panR;

        // Switch active tap and start smooth crossfade
        activeTap = nextTap;
        isCrossfading = true;
        crossfadeCount = 0;

        return { randomShiftMs, randomGainDb, clampedPan, randomPitchCents };
    }

    // Process a stereo sample pair through the humanizing delay engine
    void process(float inL, float inR, float& outL, float& outR)
    {
        // Write incoming audio to circular buffers
        bufferL[writeIndex] = inL;
        bufferR[writeIndex] = inR;

        if (isCrossfading)
        {
            // Equal-power crossfade (sine/cosine curve)
            const float progress = static_cast<float>(crossfadeCount) / static_cast<float>(crossfadeLength);
            crossfadeCount++;
            if (crossfadeCount >= crossfadeLength)
                isCrossfading = false;

            const float angle = progress * 1.5707963267948966f; // pi/2
            const float wNew = std::sin(angle);
            const float wOld = std::cos(angle);

            const int prevTap = 1 - activeTap;

            const float newL = readAndAdvanceTap(bufferL, activeTap) * taps[activeTap].panL;
            const float newR = readAndAdvanceTap(bufferR, activeTap) * taps[activeTap].panR;

            const float oldL = readAndAdvanceTap(bufferL, prevTap) * taps[prevTap].panL;
            const float oldR = readAndAdvanceTap(bufferR, prevTap) * taps[prevTap].panR;

            outL = wNew * newL + wOld * oldL;
            outR = wNew * newR + wOld * oldR;
        }
        else
        {
            outL = readAndAdvanceTap(bufferL, activeTap) * taps[activeTap].panL;
            outR = readAndAdvanceTap(bufferR, activeTap) * taps[activeTap].panR;
        }

        // Advance circular buffer write pointer
        writeIndex = (writeIndex + 1) & bufferMask;
    }

private:
    struct Tap
    {
        float delaySamples = 0.0f;
        float readOffset = 0.0f;
        float playbackRate = 1.0f;
        float gain = 1.0f;
        float panL = 1.0f;
        float panR = 1.0f;
    };

    // 4-point, 3rd-order Hermite interpolation for pristine high frequencies
    inline float readHermite(const std::vector<float>& buf, float readPos) const noexcept
    {
        const int i1 = static_cast<int>(std::floor(readPos));
        const float frac = readPos - static_cast<float>(i1);

        const int i0 = (i1 - 1 + bufferSize) & bufferMask;
        const int i1_m = i1 & bufferMask;
        const int i2 = (i1 + 1) & bufferMask;
        const int i3 = (i1 + 2) & bufferMask;

        const float y0 = buf[i0];
        const float y1 = buf[i1_m];
        const float y2 = buf[i2];
        const float y3 = buf[i3];

        const float c0 = y1;
        const float c1 = 0.5f * (y2 - y0);
        const float c2 = y0 - 2.5f * y1 + 2.0f * y2 - 0.5f * y3;
        const float c3 = 0.5f * (y3 - y0) + 1.5f * (y1 - y2);

        return ((c3 * frac + c2) * frac + c1) * frac + c0;
    }

    inline float readAndAdvanceTap(const std::vector<float>& buf, int tapIdx) noexcept
    {
        auto& tap = taps[tapIdx];

        float readPos = static_cast<float>(writeIndex) - tap.readOffset;
        if (readPos < 0.0f)
            readPos += static_cast<float>(bufferSize);

        const float sample = readHermite(buf, readPos) * tap.gain;

        // Varispeed pitch offset evolution:
        // When playbackRate > 1.0, read offset decreases (reads faster)
        // When playbackRate < 1.0, read offset increases (reads slower)
        tap.readOffset += (1.0f - tap.playbackRate);
        if (tap.readOffset < 1.0f)
            tap.readOffset = 1.0f;

        // Smoothly decay playback rate towards 1.0 to bound the drift
        tap.playbackRate += (1.0f - tap.playbackRate) * rateDecayFactor;

        return sample;
    }

    static constexpr int bufferSize = 65536; // power of 2
    static constexpr int bufferMask = bufferSize - 1;

    std::vector<float> bufferL;
    std::vector<float> bufferR;
    int writeIndex = 0;

    Tap taps[2];
    int activeTap = 0;
    bool isCrossfading = false;
    int crossfadeCount = 0;
    int crossfadeLength = 176;
    float rateDecayFactor = 0.0005f;

    double sampleRate = 44100.0;
    juce::Random random;
};
