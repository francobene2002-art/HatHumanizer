/*
  ==============================================================================

    PluginProcessor.cpp
    HatHumanizer - Audio Processor Implementation with Trap Roll Generator

  ==============================================================================
*/

#include "PluginProcessor.h"
#include "PluginEditor.h"

//==============================================================================
HatHumanizerAudioProcessor::HatHumanizerAudioProcessor()
#ifndef JucePlugin_PreferredChannelConfigurations
     : AudioProcessor (BusesProperties()
                     #if ! JucePlugin_IsMidiEffect
                      #if ! JucePlugin_IsSynth
                       .withInput  ("Input",  juce::AudioChannelSet::stereo(), true)
                      #endif
                       .withOutput ("Output", juce::AudioChannelSet::stereo(), true)
                     #endif
                       ),
#else
     :
#endif
       apvts (*this, nullptr, "Parameters", createParameterLayout())
{
    thresholdParam      = apvts.getRawParameterValue ("threshold");
    holdOffParam        = apvts.getRawParameterValue ("holdOff");
    filterFreqParam     = apvts.getRawParameterValue ("filterFreq");
    timingShiftParam    = apvts.getRawParameterValue ("timingShift");
    gainVarParam        = apvts.getRawParameterValue ("gainVar");
    panVarParam         = apvts.getRawParameterValue ("panVar");
    pitchVarParam       = apvts.getRawParameterValue ("pitchVar");
    humanizeAmountParam = apvts.getRawParameterValue ("amount");
    dryWetParam         = apvts.getRawParameterValue ("dryWet");
    outputGainParam     = apvts.getRawParameterValue ("outputGain");

    // Trap Roll parameters
    rollChanceParam   = apvts.getRawParameterValue ("rollChance");
    rollRateParam     = apvts.getRawParameterValue ("rollRate");
    rollHitsParam     = apvts.getRawParameterValue ("rollHits");
    rollPitchParam    = apvts.getRawParameterValue ("rollPitch");
    rollDynamicsParam = apvts.getRawParameterValue ("rollDynamics");
}

HatHumanizerAudioProcessor::~HatHumanizerAudioProcessor()
{
}

//==============================================================================
juce::AudioProcessorValueTreeState::ParameterLayout HatHumanizerAudioProcessor::createParameterLayout()
{
    juce::AudioProcessorValueTreeState::ParameterLayout layout;

    // 1. Detection Parameters
    layout.add (std::make_unique<juce::AudioParameterFloat> (
        juce::ParameterID { "threshold", 1 },
        "Threshold",
        juce::NormalisableRange<float> (-60.0f, 0.0f, 0.1f),
        -20.0f,
        juce::AudioParameterFloatAttributes().withLabel ("dB")));

    layout.add (std::make_unique<juce::AudioParameterFloat> (
        juce::ParameterID { "holdOff", 1 },
        "Hold-Off",
        juce::NormalisableRange<float> (10.0f, 300.0f, 1.0f),
        60.0f,
        juce::AudioParameterFloatAttributes().withLabel ("ms")));

    layout.add (std::make_unique<juce::AudioParameterFloat> (
        juce::ParameterID { "filterFreq", 1 },
        "HP Filter",
        juce::NormalisableRange<float> (150.0f, 8000.0f, 1.0f, 0.35f),
        2000.0f,
        juce::AudioParameterFloatAttributes().withLabel ("Hz")));

    // 2. Humanization Parameters
    layout.add (std::make_unique<juce::AudioParameterFloat> (
        juce::ParameterID { "timingShift", 1 },
        "Timing Shift",
        juce::NormalisableRange<float> (0.0f, 25.0f, 0.1f),
        8.0f,
        juce::AudioParameterFloatAttributes().withLabel ("ms")));

    layout.add (std::make_unique<juce::AudioParameterFloat> (
        juce::ParameterID { "gainVar", 1 },
        "Gain Var",
        juce::NormalisableRange<float> (0.0f, 6.0f, 0.1f),
        1.5f,
        juce::AudioParameterFloatAttributes().withLabel ("dB")));

    layout.add (std::make_unique<juce::AudioParameterFloat> (
        juce::ParameterID { "panVar", 1 },
        "Pan Var",
        juce::NormalisableRange<float> (0.0f, 100.0f, 1.0f),
        25.0f,
        juce::AudioParameterFloatAttributes().withLabel ("%")));

    layout.add (std::make_unique<juce::AudioParameterFloat> (
        juce::ParameterID { "pitchVar", 1 },
        "Pitch Var",
        juce::NormalisableRange<float> (0.0f, 100.0f, 0.5f),
        25.0f,
        juce::AudioParameterFloatAttributes().withLabel ("cents")));

    layout.add (std::make_unique<juce::AudioParameterFloat> (
        juce::ParameterID { "amount", 1 },
        "Humanize Amount",
        juce::NormalisableRange<float> (0.0f, 100.0f, 1.0f),
        100.0f,
        juce::AudioParameterFloatAttributes().withLabel ("%")));

    // 3. Trap Roll Generator Parameters
    layout.add (std::make_unique<juce::AudioParameterFloat> (
        juce::ParameterID { "rollChance", 1 },
        "Roll Chance",
        juce::NormalisableRange<float> (0.0f, 100.0f, 1.0f),
        0.0f, // Off by default (0%)
        juce::AudioParameterFloatAttributes().withLabel ("%")));

    layout.add (std::make_unique<juce::AudioParameterChoice> (
        juce::ParameterID { "rollRate", 1 },
        "Roll Rate",
        juce::StringArray { "1/16", "1/24T", "1/32", "1/48T", "1/64" },
        2)); // Default: 1/32

    layout.add (std::make_unique<juce::AudioParameterFloat> (
        juce::ParameterID { "rollHits", 1 },
        "Roll Hits",
        juce::NormalisableRange<float> (2.0f, 16.0f, 1.0f),
        6.0f,
        juce::AudioParameterFloatAttributes().withLabel ("hits")));

    layout.add (std::make_unique<juce::AudioParameterFloat> (
        juce::ParameterID { "rollPitch", 1 },
        "Roll Pitch Slide",
        juce::NormalisableRange<float> (-12.0f, 12.0f, 0.5f),
        0.0f,
        juce::AudioParameterFloatAttributes().withLabel ("st")));

    layout.add (std::make_unique<juce::AudioParameterFloat> (
        juce::ParameterID { "rollDynamics", 1 },
        "Roll Dynamics",
        juce::NormalisableRange<float> (-100.0f, 100.0f, 1.0f),
        -20.0f,
        juce::AudioParameterFloatAttributes().withLabel ("%")));

    // 4. Output Parameters
    layout.add (std::make_unique<juce::AudioParameterFloat> (
        juce::ParameterID { "dryWet", 1 },
        "Dry / Wet",
        juce::NormalisableRange<float> (0.0f, 100.0f, 1.0f),
        100.0f,
        juce::AudioParameterFloatAttributes().withLabel ("%")));

    layout.add (std::make_unique<juce::AudioParameterFloat> (
        juce::ParameterID { "outputGain", 1 },
        "Output Gain",
        juce::NormalisableRange<float> (-18.0f, 18.0f, 0.1f),
        0.0f,
        juce::AudioParameterFloatAttributes().withLabel ("dB")));

    return layout;
}

//==============================================================================
const juce::String HatHumanizerAudioProcessor::getName() const
{
    return JucePlugin_Name;
}

bool HatHumanizerAudioProcessor::acceptsMidi() const
{
   #if JucePlugin_WantsMidiInput
    return true;
   #else
    return false;
   #endif
}

bool HatHumanizerAudioProcessor::producesMidi() const
{
   #if JucePlugin_ProducesMidiOutput
    return true;
   #else
    return false;
   #endif
}

bool HatHumanizerAudioProcessor::isMidiEffect() const
{
   #if JucePlugin_IsMidiEffect
    return true;
   #else
    return false;
   #endif
}

double HatHumanizerAudioProcessor::getTailLengthSeconds() const
{
    return 0.1;
}

int HatHumanizerAudioProcessor::getNumPrograms()
{
    return 1;
}

int HatHumanizerAudioProcessor::getCurrentProgram()
{
    return 0;
}

void HatHumanizerAudioProcessor::setCurrentProgram (int)
{
}

const juce::String HatHumanizerAudioProcessor::getProgramName (int)
{
    return {};
}

void HatHumanizerAudioProcessor::changeProgramName (int, const juce::String&)
{
}

//==============================================================================
void HatHumanizerAudioProcessor::prepareToPlay (double sampleRate, int samplesPerBlock)
{
    juce::ignoreUnused (samplesPerBlock);

    transientDetector.prepare (sampleRate);
    humanizerEngine.prepare (sampleRate);
    rollGenerator.prepare (sampleRate);

    // 20 ms smoothing time for global controls to prevent zipper noise
    dryWetSmoother.reset (sampleRate, 0.02);
    outputGainSmoother.reset (sampleRate, 0.02);

    dryWetSmoother.setCurrentAndTargetValue (dryWetParam != nullptr ? dryWetParam->load() * 0.01f : 1.0f);
    outputGainSmoother.setCurrentAndTargetValue (outputGainParam != nullptr ? juce::Decibels::decibelsToGain (outputGainParam->load()) : 1.0f);

    std::fill (std::begin (scopeBuffer), std::end (scopeBuffer), 0.0f);
    scopeWriteIndex.store (0);
    scopeDownsampleCounter = 0;
    for (auto& h : hitHistory)
        h = HitRecord();
}

void HatHumanizerAudioProcessor::releaseResources()
{
    transientDetector.reset();
    humanizerEngine.reset();
    rollGenerator.reset();
}

#ifndef JucePlugin_PreferredChannelConfigurations
bool HatHumanizerAudioProcessor::isBusesLayoutSupported (const BusesLayout& layouts) const
{
  #if JucePlugin_IsMidiEffect
    juce::ignoreUnused (layouts);
    return true;
  #else
    if (layouts.getMainOutputChannelSet() != juce::AudioChannelSet::mono()
     && layouts.getMainOutputChannelSet() != juce::AudioChannelSet::stereo())
        return false;

   #if ! JucePlugin_IsSynth
    if (layouts.getMainOutputChannelSet() != layouts.getMainInputChannelSet())
        return false;
   #endif

    return true;
  #endif
}
#endif

void HatHumanizerAudioProcessor::processBlock (juce::AudioBuffer<float>& buffer, juce::MidiBuffer& midiMessages)
{
    juce::ignoreUnused (midiMessages);
    juce::ScopedNoDenormals noDenormals;

    auto totalNumInputChannels  = getTotalNumInputChannels();
    auto totalNumOutputChannels = getTotalNumOutputChannels();

    for (auto i = totalNumInputChannels; i < totalNumOutputChannels; ++i)
        buffer.clear (i, 0, buffer.getNumSamples());

    if (totalNumInputChannels == 0)
        return;

    // Read DAW BPM if available
    double currentBpm = 140.0;
    if (auto* playHead = getPlayHead())
    {
        if (auto posInfo = playHead->getPosition())
        {
            if (posInfo->getBpm().hasValue())
                currentBpm = *posInfo->getBpm();
        }
    }

    const float curThreshold    = thresholdParam->load (std::memory_order_relaxed);
    const float curHoldOff      = holdOffParam->load (std::memory_order_relaxed);
    const float curFilterFreq   = filterFreqParam->load (std::memory_order_relaxed);
    const float curShift        = timingShiftParam->load (std::memory_order_relaxed);
    const float curGainVar      = gainVarParam->load (std::memory_order_relaxed);
    const float curPanVar       = panVarParam->load (std::memory_order_relaxed);
    const float curPitchVar     = pitchVarParam->load (std::memory_order_relaxed);
    const float curAmount       = humanizeAmountParam->load (std::memory_order_relaxed);
    const float curDryWet       = dryWetParam->load (std::memory_order_relaxed) * 0.01f;
    const float curOutGain      = juce::Decibels::decibelsToGain (outputGainParam->load (std::memory_order_relaxed));

    const float curRollChance   = rollChanceParam->load (std::memory_order_relaxed);
    const int   curRollRate     = static_cast<int>(rollRateParam->load (std::memory_order_relaxed));
    const int   curRollHits     = static_cast<int>(rollHitsParam->load (std::memory_order_relaxed));
    const float curRollPitch    = rollPitchParam->load (std::memory_order_relaxed);
    const float curRollDynamics = rollDynamicsParam->load (std::memory_order_relaxed);

    transientDetector.setThreshold (curThreshold);
    transientDetector.setHoldOff (curHoldOff);
    transientDetector.setFilterFrequency (curFilterFreq);

    dryWetSmoother.setTargetValue (curDryWet);
    outputGainSmoother.setTargetValue (curOutGain);

    const int numSamples = buffer.getNumSamples();
    auto* channelL = buffer.getWritePointer (0);
    auto* channelR = (totalNumInputChannels > 1) ? buffer.getWritePointer (1) : channelL;

    for (int sample = 0; sample < numSamples; ++sample)
    {
        const float inL = channelL[sample];
        const float inR = channelR[sample];

        // 1. Transient Detection
        if (transientDetector.processSample (inL, inR))
        {
            // Evaluate trap roll trigger
            rollGenerator.onTransientDetected (currentBpm, curRollChance, curRollRate,
                                              curRollHits, curRollPitch, curRollDynamics);

            // Trigger humanizer micro-variations
            auto hit = humanizerEngine.triggerHit (curShift, curGainVar, curPanVar, curPitchVar, curAmount);
            hitTriggered.store (true, std::memory_order_relaxed);

            // Record hit into History Matrix (shift right, insert at 0)
            for (int h = maxHistoryHits - 1; h > 0; --h)
                hitHistory[h] = hitHistory[h - 1];

            hitHistory[0] = { hit.pitchCents, hit.gainDb, hit.pan, hit.timingShiftMs, true };
            hitCounter.fetch_add (1, std::memory_order_relaxed);
        }

        // 1b. Real-time Oscilloscope Feed (downsampled for ~35ms transient view)
        if (++scopeDownsampleCounter >= 6)
        {
            scopeDownsampleCounter = 0;
            const float mag = (std::abs (inL) + std::abs (inR)) * 0.5f;
            const int wIdx = scopeWriteIndex.load (std::memory_order_relaxed);
            scopeBuffer[wIdx] = mag;
            scopeWriteIndex.store ((wIdx + 1) & (scopeBufferSize - 1), std::memory_order_relaxed);
        }

        // 2. Trap Roll Generator (creates micro-enveloped choke rolls if active)
        float audioToHumanizeL = inL;
        float audioToHumanizeR = inR;
        rollGenerator.processSample (inL, inR, audioToHumanizeL, audioToHumanizeR);

        // 3. Dual-tap micro-delay humanizer processing
        float wetL = 0.0f;
        float wetR = 0.0f;
        humanizerEngine.process (audioToHumanizeL, audioToHumanizeR, wetL, wetR);

        // 4. Smooth dry/wet and master output gain
        const float smoothMix = dryWetSmoother.getNextValue();
        const float smoothGain = outputGainSmoother.getNextValue();

        const float outL = (inL * (1.0f - smoothMix) + wetL * smoothMix) * smoothGain;
        const float outR = (inR * (1.0f - smoothMix) + wetR * smoothMix) * smoothGain;

        channelL[sample] = outL;
        if (totalNumInputChannels > 1)
            channelR[sample] = outR;
    }
}

//==============================================================================
void HatHumanizerAudioProcessor::getScopeSnapshot (float* dest, int numSamples, float& thresholdLinearOut) const noexcept
{
    thresholdLinearOut = juce::Decibels::decibelsToGain (thresholdParam != nullptr ? thresholdParam->load (std::memory_order_relaxed) : -24.0f);
    const int count = std::min (numSamples, scopeBufferSize);
    const int start = scopeWriteIndex.load (std::memory_order_relaxed);
    for (int i = 0; i < count; ++i)
    {
        const int idx = (start + i) & (scopeBufferSize - 1);
        dest[i] = scopeBuffer[idx];
    }
}

void HatHumanizerAudioProcessor::getHitHistorySnapshot (HitRecord* dest, int maxHits) const noexcept
{
    for (int i = 0; i < maxHits && i < maxHistoryHits; ++i)
        dest[i] = hitHistory[i];
}

//==============================================================================
bool HatHumanizerAudioProcessor::hasEditor() const
{
    return true;
}

juce::AudioProcessorEditor* HatHumanizerAudioProcessor::createEditor()
{
    return new HatHumanizerAudioProcessorEditor (*this);
}

//==============================================================================
void HatHumanizerAudioProcessor::getStateInformation (juce::MemoryBlock& destData)
{
    auto state = apvts.copyState();
    std::unique_ptr<juce::XmlElement> xml (state.createXml());
    copyXmlToBinary (*xml, destData);
}

void HatHumanizerAudioProcessor::setStateInformation (const void* data, int sizeInBytes)
{
    std::unique_ptr<juce::XmlElement> xmlState (getXmlFromBinary (data, sizeInBytes));
    if (xmlState.get() != nullptr)
        if (xmlState->hasTagName (apvts.state.getType()))
            apvts.replaceState (juce::ValueTree::fromXml (*xmlState));
}

//==============================================================================
juce::AudioProcessor* JUCE_CALLTYPE createPluginFilter()
{
    return new HatHumanizerAudioProcessor();
}
