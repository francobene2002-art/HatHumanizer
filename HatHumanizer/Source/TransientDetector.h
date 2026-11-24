/*
  ==============================================================================

    TransientDetector.h
    HatHumanizer - Transient Detection Engine with 12 dB/Oct Biquad HPF

  ==============================================================================
*/

#pragma once

#include <JuceHeader.h>
#include <cmath>

class TransientDetector
{
public:
    TransientDetector() = default;

    void prepare(double newSampleRate)
    {
        sampleRate = (newSampleRate > 0.0) ? newSampleRate : 44100.0;
        reset();
        updateFilterCoefficients();
        updateEnvelopeCoefficients();
    }

    void reset()
    {
        envelope = 0.0f;
        z1 = 0.0f;
        z2 = 0.0f;
        samplesSinceLastTrigger = 999999;
        isArmed = true;
    }

    void setThreshold(float thresholdDb)
    {
        thresholdLinear = juce::Decibels::decibelsToGain(thresholdDb);
    }

    void setHoldOff(float holdOffMs)
    {
        holdOffSamples = static_cast<int64_t>(std::max(1.0, (double)holdOffMs) * 0.001 * sampleRate);
    }

    // Adjustable high-pass filter frequency to reject snare bleed
    void setFilterFrequency(float freqHz)
    {
        const float clampedFreq = juce::jlimit(100.0f, static_cast<float>(sampleRate * 0.45), freqHz);
        if (std::abs(clampedFreq - filterFreqHz) > 1.0f)
        {
            filterFreqHz = clampedFreq;
            updateFilterCoefficients();
        }
    }

    // Process a single audio sample (L and R). Returns true if a transient hit is detected.
    bool processSample(float inL, float inR)
    {
        // 1. Mono fold on raw bipolar signal (preserves phase & true frequency content)
        const float inputMono = (inL + inR) * 0.5f;

        // 2. 2nd-order (12 dB/octave) Butterworth High-Pass filter on audio signal
        // True AC filtering: rejects kick/sub (40-100 Hz), snare body (200-800 Hz),
        // cleanly isolating the high-frequency sizzle of the hi-hat (> 2 kHz)
        const float hpOut = b0 * inputMono + z1;
        z1 = b1 * inputMono - a1 * hpOut + z2;
        z2 = b2 * inputMono - a2 * hpOut;
        const float filtered = std::abs(hpOut);

        // 3. Fast attack / controlled release envelope follower
        if (filtered > envelope)
            envelope += attackAlpha * (filtered - envelope);
        else
            envelope += releaseAlpha * (filtered - envelope);

        samplesSinceLastTrigger++;

        // 4. Schmitt trigger arming logic:
        // Re-arms when envelope drops below threshold * 0.707 (-3 dB hysteresis)
        // or once the hold-off duration has elapsed.
        if (envelope < (thresholdLinear * 0.707f) || samplesSinceLastTrigger >= holdOffSamples)
        {
            isArmed = true;
        }

        // 5. Transient trigger evaluation
        if (isArmed && envelope >= thresholdLinear && samplesSinceLastTrigger >= holdOffSamples)
        {
            isArmed = false;
            samplesSinceLastTrigger = 0;
            return true;
        }

        return false;
    }

    float getEnvelope() const noexcept { return envelope; }

private:
    void updateFilterCoefficients()
    {
        // 2nd-order Butterworth HPF (Q = 0.7071)
        const double w0 = 2.0 * juce::MathConstants<double>::pi * static_cast<double>(filterFreqHz) / sampleRate;
        const double cosw0 = std::cos(w0);
        const double sinw0 = std::sin(w0);
        const double alpha = sinw0 / (2.0 * 0.7071067811865475);

        const double a0 = 1.0 + alpha;
        b0 = static_cast<float>(((1.0 + cosw0) * 0.5) / a0);
        b1 = static_cast<float>(-(1.0 + cosw0) / a0);
        b2 = static_cast<float>(((1.0 + cosw0) * 0.5) / a0);
        a1 = static_cast<float>((-2.0 * cosw0) / a0);
        a2 = static_cast<float>((1.0 - alpha) / a0);
    }

    void updateEnvelopeCoefficients()
    {
        // ~0.5 ms attack time for crisp transient response
        attackAlpha = 1.0f - std::exp(-1.0f / (0.0005f * static_cast<float>(sampleRate)));

        // ~20 ms release time
        releaseAlpha = 1.0f - std::exp(-1.0f / (0.020f * static_cast<float>(sampleRate)));
    }

    double sampleRate = 44100.0;
    float filterFreqHz = 2000.0f; // Default 2000 Hz: aggressively rejects snare drum bleed
    float thresholdLinear = 0.1f; // ~ -20 dB
    int64_t holdOffSamples = 2646; // ~60 ms at 44.1kHz
    int64_t samplesSinceLastTrigger = 999999;
    bool isArmed = true;

    float envelope = 0.0f;

    // Biquad filter state and coefficients
    float z1 = 0.0f;
    float z2 = 0.0f;
    float b0 = 1.0f, b1 = -2.0f, b2 = 1.0f;
    float a1 = 0.0f, a2 = 0.0f;

    float attackAlpha = 0.05f;
    float releaseAlpha = 0.001f;
};
