/*
  ==============================================================================

    TrapRollGenerator.h
    HatHumanizer - Real-Time Trap Hi-Hat Roll Generator with Choke & Micro-Enveloping

  ==============================================================================
*/

#pragma once

#include <JuceHeader.h>
#include <vector>
#include <cmath>
#include <algorithm>

class TrapRollGenerator
{
public:
    TrapRollGenerator()
    {
        sliceBufferL.resize(sliceSize, 0.0f);
        sliceBufferR.resize(sliceSize, 0.0f);
    }

    void prepare(double newSampleRate)
    {
        sampleRate = (newSampleRate > 0.0) ? newSampleRate : 44100.0;
        reset();

        fadeOutSamples = std::max(16, static_cast<int>(0.0020 * sampleRate)); // 2.0 ms choke fade-out
        fadeInSamples  = std::max(8,  static_cast<int>(0.0006 * sampleRate)); // 0.6 ms soft attack fade-in
    }

    void reset()
    {
        std::fill(sliceBufferL.begin(), sliceBufferL.end(), 0.0f);
        std::fill(sliceBufferR.begin(), sliceBufferR.end(), 0.0f);
        sliceWritePos = 0;

        isRolling = false;
        currentRollHit = 0;
        totalRollHits = 0;
        sampleCounter = 0;
        rollBlend = 0.0f;

        for (int i = 0; i < 2; ++i)
        {
            voices[i].active = false;
            voices[i].readPos = 0.0f;
            voices[i].playbackRate = 1.0f;
            voices[i].gain = 1.0f;
            voices[i].fadeState = FadeState::Off;
            voices[i].fadeProgress = 0.0f;
        }
        activeVoice = 0;
    }

    void triggerManualRoll()
    {
        manualTriggerPending.store(true, std::memory_order_relaxed);
    }

    // Called when TransientDetector detects a new hi-hat hit
    void onTransientDetected(double bpm, float rollChancePercent, int subdivIndex,
                             int rollHits, float pitchSlideSemitones, float velocityDynamicsPercent)
    {
        const bool manual = manualTriggerPending.exchange(false, std::memory_order_relaxed);
        const bool chanceTrigger = (rollChancePercent > 0.5f && (random.nextFloat() * 100.0f < rollChancePercent));

        if (manual || chanceTrigger)
        {
            startRoll(bpm, subdivIndex, rollHits, pitchSlideSemitones, velocityDynamicsPercent);
        }
        else
        {
            // If already rolling and an unexpected live hit arrives, smoothly choke the roll
            if (isRolling)
            {
                stopRollSmoothly();
            }
        }
    }

    // Processes a sample pair. Returns true if roll is currently sounding audio.
    bool processSample(float dryL, float dryR, float& outL, float& outR)
    {
        // 1. Continuously capture incoming audio into circular slice buffer
        sliceBufferL[sliceWritePos] = dryL;
        sliceBufferR[sliceWritePos] = dryR;
        sliceWritePos = (sliceWritePos + 1) & sliceMask;

        if (!isRolling && rollBlend <= 0.0001f)
        {
            outL = dryL;
            outR = dryR;
            return false;
        }

        // 2. Roll Hit Scheduler
        if (isRolling)
        {
            sampleCounter++;
            if (sampleCounter >= samplesBetweenHits)
            {
                sampleCounter = 0;
                currentRollHit++;

                if (currentRollHit >= totalRollHits)
                {
                    stopRollSmoothly();
                }
                else
                {
                    spawnNextRollHit();
                }
            }
        }

        // 3. Render Voices with Choke Micro-Envelopes
        float rollL = 0.0f;
        float rollR = 0.0f;

        for (int i = 0; i < 2; ++i)
        {
            if (voices[i].active)
            {
                float vL = 0.0f, vR = 0.0f;
                renderVoice(voices[i], vL, vR);
                rollL += vL;
                rollR += vR;
            }
        }

        // 4. Smoothly blend between live dry audio and roll generator
        if (isRolling && currentRollHit > 0)
        {
            rollBlend = std::min(1.0f, rollBlend + blendStep);
        }
        else
        {
            rollBlend = std::max(0.0f, rollBlend - blendStep);
        }

        // Equal-power crossfade between live input and roll generator
        const float wRoll = std::sin(rollBlend * 1.57079632679f);
        const float wDry  = std::cos(rollBlend * 1.57079632679f);

        outL = dryL * wDry + rollL * wRoll;
        outR = dryR * wDry + rollR * wRoll;

        return isRolling;
    }

    bool isRollActive() const noexcept { return isRolling; }

private:
    enum class FadeState { Off, FadingIn, Playing, FadingOut };

    struct Voice
    {
        bool active = false;
        float readPos = 0.0f;
        float playbackRate = 1.0f;
        float gain = 1.0f;
        FadeState fadeState = FadeState::Off;
        float fadeProgress = 0.0f;
    };

    void startRoll(double bpm, int subdivIndex, int rollHits, float pitchSlideSemitones, float velocityDynamicsPercent)
    {
        isRolling = true;
        currentRollHit = 0;
        totalRollHits = juce::jlimit(2, 16, rollHits);
        sampleCounter = 0;
        savedPitchSlide = pitchSlideSemitones;
        savedDynamics = velocityDynamicsPercent;

        // Capture starting position (slightly behind write pos to ensure full transient inclusion)
        sliceStartPos = (sliceWritePos - 64 + sliceSize) & sliceMask;

        // Calculate subdivision rate synced to BPM
        const double safeBpm = juce::jlimit(40.0, 300.0, (bpm > 20.0 ? bpm : 140.0));
        const double secPerBeat = 60.0 / safeBpm;

        double subdivFactor = 0.125; // default 1/32
        switch (subdivIndex)
        {
            case 0: subdivFactor = 0.25;            break; // 1/16
            case 1: subdivFactor = 0.25 / 1.5;      break; // 1/24T (triplet)
            case 2: subdivFactor = 0.125;           break; // 1/32
            case 3: subdivFactor = 0.125 / 1.5;     break; // 1/48T (triplet)
            case 4: subdivFactor = 0.0625;          break; // 1/64
            default: subdivFactor = 0.125;          break;
        }

        samplesBetweenHits = std::max(64, static_cast<int>(secPerBeat * subdivFactor * sampleRate));
        blendStep = 1.0f / static_cast<float>(std::max(16, static_cast<int>(0.002 * sampleRate)));
    }

    void spawnNextRollHit()
    {
        // 1. Choke the previous voice with a fast 2 ms fade-out
        if (voices[activeVoice].active && voices[activeVoice].fadeState != FadeState::FadingOut)
        {
            voices[activeVoice].fadeState = FadeState::FadingOut;
            voices[activeVoice].fadeProgress = 1.0f;
        }

        // 2. Switch to alternate voice
        activeVoice = 1 - activeVoice;
        auto& next = voices[activeVoice];

        // 3. Pitch Slide progression across the roll
        const float progress = static_cast<float>(currentRollHit) / static_cast<float>(totalRollHits - 1);
        const float pitchOffset = savedPitchSlide * progress;
        next.playbackRate = std::pow(2.0f, pitchOffset / 12.0f);

        // 4. Velocity Dynamics (Crescendo / Decrescendo)
        const float dynGain = 1.0f + (savedDynamics * 0.01f) * progress;
        next.gain = std::max(0.05f, dynGain);

        // 5. Initialize voice playback at slice origin
        next.readPos = static_cast<float>(sliceStartPos);
        next.fadeState = FadeState::FadingIn;
        next.fadeProgress = 0.0f;
        next.active = true;
    }

    void stopRollSmoothly()
    {
        isRolling = false;
        for (int i = 0; i < 2; ++i)
        {
            if (voices[i].active && voices[i].fadeState != FadeState::FadingOut)
            {
                voices[i].fadeState = FadeState::FadingOut;
                voices[i].fadeProgress = 1.0f;
            }
        }
    }

    void renderVoice(Voice& v, float& vL, float& vR)
    {
        // Calculate smooth fade envelope to guarantee 100% click-free choke
        float env = 1.0f;

        if (v.fadeState == FadeState::FadingIn)
        {
            v.fadeProgress += 1.0f / static_cast<float>(fadeInSamples);
            if (v.fadeProgress >= 1.0f)
            {
                v.fadeProgress = 1.0f;
                v.fadeState = FadeState::Playing;
            }
            // Smoothstep curve (3x^2 - 2x^3) for soft onset
            const float p = v.fadeProgress;
            env = p * p * (3.0f - 2.0f * p);
        }
        else if (v.fadeState == FadeState::FadingOut)
        {
            v.fadeProgress -= 1.0f / static_cast<float>(fadeOutSamples);
            if (v.fadeProgress <= 0.0f)
            {
                v.fadeProgress = 0.0f;
                v.fadeState = FadeState::Off;
                v.active = false;
                vL = 0.0f;
                vR = 0.0f;
                return;
            }
            // Smoothstep curve for click-free choke
            const float p = v.fadeProgress;
            env = p * p * (3.0f - 2.0f * p);
        }

        // Hermite 4-point interpolated read from circular slice buffer
        vL = readHermite(sliceBufferL, v.readPos) * v.gain * env;
        vR = readHermite(sliceBufferR, v.readPos) * v.gain * env;

        // Advance read position
        v.readPos += v.playbackRate;
        if (v.readPos >= static_cast<float>(sliceSize))
            v.readPos -= static_cast<float>(sliceSize);
    }

    // 4-point, 3rd-order Hermite interpolation
    inline float readHermite(const std::vector<float>& buf, float readPos) const noexcept
    {
        const int i1 = static_cast<int>(std::floor(readPos));
        const float frac = readPos - static_cast<float>(i1);

        const int i0 = (i1 - 1 + sliceSize) & sliceMask;
        const int i1_m = i1 & sliceMask;
        const int i2 = (i1 + 1) & sliceMask;
        const int i3 = (i1 + 2) & sliceMask;

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

    static constexpr int sliceSize = 16384; // ~370 ms buffer at 44.1kHz
    static constexpr int sliceMask = sliceSize - 1;

    std::vector<float> sliceBufferL;
    std::vector<float> sliceBufferR;
    int sliceWritePos = 0;
    int sliceStartPos = 0;

    bool isRolling = false;
    int currentRollHit = 0;
    int totalRollHits = 4;
    int samplesBetweenHits = 5512;
    int sampleCounter = 0;

    float savedPitchSlide = 0.0f;
    float savedDynamics = 0.0f;
    float rollBlend = 0.0f;
    float blendStep = 0.01f;

    Voice voices[2];
    int activeVoice = 0;

    int fadeOutSamples = 88; // 2 ms
    int fadeInSamples  = 26; // 0.6 ms

    double sampleRate = 44100.0;
    std::atomic<bool> manualTriggerPending { false };
    juce::Random random;
};
