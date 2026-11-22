/*
  ==============================================================================

    PluginProcessor.h
    HatHumanizer - Audio Processor Header with Trap Roll Generator

  ==============================================================================
*/

#pragma once

#include <JuceHeader.h>
#include "TransientDetector.h"
#include "HumanizerEngine.h"
#include "TrapRollGenerator.h"

//==============================================================================
class HatHumanizerAudioProcessor  : public juce::AudioProcessor
{
public:
    //==============================================================================
    HatHumanizerAudioProcessor();
    ~HatHumanizerAudioProcessor() override;

    //==============================================================================
    void prepareToPlay (double sampleRate, int samplesPerBlock) override;
    void releaseResources() override;

   #ifndef JucePlugin_PreferredChannelConfigurations
    bool isBusesLayoutSupported (const BusesLayout& layouts) const override;
   #endif

    void processBlock (juce::AudioBuffer<float>&, juce::MidiBuffer&) override;

    //==============================================================================
    juce::AudioProcessorEditor* createEditor() override;
    bool hasEditor() const override;

    //==============================================================================
    const juce::String getName() const override;

    bool acceptsMidi() const override;
    bool producesMidi() const override;
    bool isMidiEffect() const override;
    double getTailLengthSeconds() const override;

    //==============================================================================
    int getNumPrograms() override;
    int getCurrentProgram() override;
    void setCurrentProgram (int index) override;
    const juce::String getProgramName (int index) override;
    void changeProgramName (int index, const juce::String& newName) override;

    //==============================================================================
    void getStateInformation (juce::MemoryBlock& destData) override;
    void setStateInformation (const void* data, int sizeInBytes) override;

    //==============================================================================
    juce::AudioProcessorValueTreeState& getAPVTS() noexcept { return apvts; }
    bool consumeHitTriggered() noexcept { return hitTriggered.exchange(false, std::memory_order_relaxed); }
    void triggerManualRoll() noexcept { rollGenerator.triggerManualRoll(); }

    struct HitRecord
    {
        float pitchCents = 0.0f;
        float gainDb = 0.0f;
        float pan = 0.0f;
        float timingMs = 0.0f;
        bool active = false;
    };

    static constexpr int maxHistoryHits = 8;
    static constexpr int scopeBufferSize = 256;

    void getScopeSnapshot (float* dest, int numSamples, float& thresholdLinearOut) const noexcept;
    void getHitHistorySnapshot (HitRecord* dest, int maxHits) const noexcept;

    static juce::AudioProcessorValueTreeState::ParameterLayout createParameterLayout();

private:
    //==============================================================================
    juce::AudioProcessorValueTreeState apvts;

    // DSP components
    TransientDetector transientDetector;
    HumanizerEngine humanizerEngine;
    TrapRollGenerator rollGenerator;

    // Cached parameter pointers for lock-free audio thread access
    std::atomic<float>* thresholdParam      = nullptr;
    std::atomic<float>* holdOffParam        = nullptr;
    std::atomic<float>* filterFreqParam     = nullptr;
    std::atomic<float>* timingShiftParam    = nullptr;
    std::atomic<float>* gainVarParam        = nullptr;
    std::atomic<float>* panVarParam         = nullptr;
    std::atomic<float>* pitchVarParam       = nullptr;
    std::atomic<float>* humanizeAmountParam = nullptr;
    std::atomic<float>* dryWetParam         = nullptr;
    std::atomic<float>* outputGainParam     = nullptr;

    // Trap Roll parameters
    std::atomic<float>* rollChanceParam   = nullptr;
    std::atomic<float>* rollRateParam     = nullptr;
    std::atomic<float>* rollHitsParam     = nullptr;
    std::atomic<float>* rollPitchParam    = nullptr;
    std::atomic<float>* rollDynamicsParam = nullptr;

    // Parameter smoothing for click-free control movement
    juce::SmoothedValue<float, juce::ValueSmoothingTypes::Linear> dryWetSmoother;
    juce::SmoothedValue<float, juce::ValueSmoothingTypes::Linear> outputGainSmoother;

    // Real-time transient trigger indicator for UI LED
    std::atomic<bool> hitTriggered { false };

    // Real-time Visualizer buffers
    float scopeBuffer[scopeBufferSize] = { 0.0f };
    std::atomic<int> scopeWriteIndex { 0 };
    int scopeDownsampleCounter = 0;

    HitRecord hitHistory[maxHistoryHits];
    std::atomic<uint32_t> hitCounter { 0 };

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (HatHumanizerAudioProcessor)
};
