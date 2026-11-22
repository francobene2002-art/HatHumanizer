/*
  ==============================================================================

    PluginEditor.cpp
    HatHumanizer - Warm Vintage UI with Trap Roll Generator

  ==============================================================================
*/

#include "PluginProcessor.h"
#include "PluginEditor.h"

//==============================================================================
CustomKnobLookAndFeel::CustomKnobLookAndFeel()
{
    setColour (juce::Slider::textBoxOutlineColourId, juce::Colours::transparentBlack);
    setColour (juce::Slider::textBoxTextColourId,    juce::Colour (0xff2b1b11));
    setColour (juce::ComboBox::backgroundColourId,   juce::Colour (0xfff0e7d6));
    setColour (juce::ComboBox::textColourId,         juce::Colour (0xff2b1b11));
    setColour (juce::ComboBox::outlineColourId,      juce::Colour (0xffbaa384));
    setColour (juce::PopupMenu::backgroundColourId,  juce::Colour (0xfff5eedf));
    setColour (juce::PopupMenu::textColourId,        juce::Colour (0xff2b1b11));
    setColour (juce::PopupMenu::highlightedBackgroundColourId, juce::Colour (0xffe2ceb0));
    setColour (juce::PopupMenu::highlightedTextColourId,       juce::Colour (0xff1b0f08));
}

void CustomKnobLookAndFeel::drawRotarySlider (juce::Graphics& g, int x, int y, int width, int height,
                                              float sliderPosProportional, float rotaryStartAngle,
                                              float rotaryEndAngle, juce::Slider& slider)
{
    auto bounds = juce::Rectangle<int> (x, y, width, height).toFloat().reduced (4.0f);
    auto radius = juce::jmin (bounds.getWidth(), bounds.getHeight()) / 2.0f - 2.0f;
    auto center = bounds.getCentre();
    auto toAngle = rotaryStartAngle + sliderPosProportional * (rotaryEndAngle - rotaryStartAngle);

    // 1. Warm cream engraved track groove
    juce::Path bgArc;
    bgArc.addCentredArc (center.x, center.y, radius, radius, 0.0f, rotaryStartAngle, rotaryEndAngle, true);
    g.setColour (juce::Colour (0xffd6c6ad));
    g.strokePath (bgArc, juce::PathStrokeType (4.5f, juce::PathStrokeType::curved, juce::PathStrokeType::rounded));

    // 2. Active colored track
    const auto accentColor = slider.findColour (juce::Slider::rotarySliderFillColourId);
    if (toAngle > rotaryStartAngle)
    {
        juce::Path activeArc;
        activeArc.addCentredArc (center.x, center.y, radius, radius, 0.0f, rotaryStartAngle, toAngle, true);
        g.setColour (accentColor);
        g.strokePath (activeArc, juce::PathStrokeType (4.5f, juce::PathStrokeType::curved, juce::PathStrokeType::rounded));
    }

    // 3. Vintage 60s Bakelite Knob Body
    const float dialRadius = radius - 8.0f;

    // Skirt shadow
    g.setColour (juce::Colour (0x401b120c));
    g.fillEllipse (center.x - dialRadius + 1.5f, center.y - dialRadius + 2.5f, dialRadius * 2.0f, dialRadius * 2.0f);

    // Dark espresso Bakelite gradient
    juce::ColourGradient bakeliteGrad (juce::Colour (0xff38271e), center.x - dialRadius * 0.4f, center.y - dialRadius * 0.4f,
                                       juce::Colour (0xff1c120c), center.x + dialRadius * 0.6f, center.y + dialRadius * 0.6f, false);
    g.setGradientFill (bakeliteGrad);
    g.fillEllipse (center.x - dialRadius, center.y - dialRadius, dialRadius * 2.0f, dialRadius * 2.0f);

    // Rim highlight
    g.setColour (juce::Colour (0xff573e2e));
    g.drawEllipse (center.x - dialRadius, center.y - dialRadius, dialRadius * 2.0f, dialRadius * 2.0f, 1.2f);

    // 4. Center Brushed Brass Medallion
    const float brassRadius = dialRadius * 0.62f;
    juce::ColourGradient brassGrad (juce::Colour (0xffdfbe7b), center.x - brassRadius * 0.5f, center.y - brassRadius * 0.5f,
                                    juce::Colour (0xff8f6d33), center.x + brassRadius * 0.5f, center.y + brassRadius * 0.5f, false);
    g.setGradientFill (brassGrad);
    g.fillEllipse (center.x - brassRadius, center.y - brassRadius, brassRadius * 2.0f, brassRadius * 2.0f);

    g.setColour (juce::Colour (0xff543e1c));
    g.drawEllipse (center.x - brassRadius, center.y - brassRadius, brassRadius * 2.0f, brassRadius * 2.0f, 0.8f);

    // Inner dark center cap
    const float innerCapRadius = brassRadius * 0.45f;
    g.setColour (juce::Colour (0xff241710));
    g.fillEllipse (center.x - innerCapRadius, center.y - innerCapRadius, innerCapRadius * 2.0f, innerCapRadius * 2.0f);

    // 5. Vintage Bone-White Pointer Notch
    juce::Path needle;
    const float needleWidth = 3.0f;
    const float needleLength = dialRadius * 0.78f;
    needle.addRoundedRectangle (-needleWidth * 0.5f, -dialRadius + 2.0f, needleWidth, needleLength, 1.5f);
    needle.applyTransform (juce::AffineTransform::rotation (toAngle).translated (center.x, center.y));

    g.setColour (juce::Colour (0x60000000));
    needle.applyTransform (juce::AffineTransform::translation (0.8f, 1.0f));
    g.fillPath (needle);

    needle.applyTransform (juce::AffineTransform::translation (-0.8f, -1.0f));
    g.setColour (juce::Colour (0xfffcf8ee));
    g.fillPath (needle);
}

juce::Label* CustomKnobLookAndFeel::createSliderTextBox (juce::Slider& slider)
{
    auto* l = LookAndFeel_V4::createSliderTextBox (slider);
    l->setFont (juce::FontOptions (10.5f).withStyle ("Bold"));
    l->setJustificationType (juce::Justification::centred);
    l->setColour (juce::Label::backgroundColourId, juce::Colour (0x26c2ad88));
    l->setColour (juce::Label::outlineColourId,    juce::Colour (0x509a7b54));
    return l;
}

void CustomKnobLookAndFeel::drawComboBox (juce::Graphics& g, int width, int height, bool,
                                          int, int, int, int, juce::ComboBox& box)
{
    auto r = juce::Rectangle<int> (0, 0, width, height).toFloat();
    g.setColour (box.findColour (juce::ComboBox::backgroundColourId));
    g.fillRoundedRectangle (r, 4.0f);
    g.setColour (box.findColour (juce::ComboBox::outlineColourId));
    g.drawRoundedRectangle (r, 4.0f, 1.0f);

    const float arrowX = width - 14.0f;
    const float arrowY = height * 0.5f - 2.0f;
    juce::Path arrow;
    arrow.addTriangle (arrowX - 4.0f, arrowY, arrowX + 4.0f, arrowY, arrowX, arrowY + 5.0f);
    g.setColour (juce::Colour (0xff573e2e));
    g.fillPath (arrow);
}

void CustomKnobLookAndFeel::drawButtonBackground (juce::Graphics& g, juce::Button& button, const juce::Colour&,
                                                  bool shouldDrawButtonAsHighlighted, bool shouldDrawButtonAsDown)
{
    auto r = button.getLocalBounds().toFloat();
    juce::Colour base = shouldDrawButtonAsDown ? juce::Colour (0xffd8c9b2)
                      : shouldDrawButtonAsHighlighted ? juce::Colour (0xfffaf3e6)
                      : juce::Colour (0xffede1ce);

    g.setColour (base);
    g.fillRoundedRectangle (r, 4.0f);
    g.setColour (juce::Colour (0xffbaa384));
    g.drawRoundedRectangle (r, 4.0f, 1.0f);
}

//==============================================================================
HatHumanizerAudioProcessorEditor::HatHumanizerAudioProcessorEditor (HatHumanizerAudioProcessor& p)
    : AudioProcessorEditor (&p), audioProcessor (p),
      transientScope (p), hitHistoryMatrix (p)
{
    setLookAndFeel (&customLnf);

    // Warm Vintage Palette
    const juce::Colour rustTerracotta (0xffb84826);  // Detection
    const juce::Colour goldenMustard  (0xffcb8016);  // Humanization
    const juce::Colour trapPlum       (0xff94384a);  // Trap Rolls
    const juce::Colour vintageOlive   (0xff566b42);  // Output

    // 1. Detection Knobs
    setupKnob (thresholdSlider,  thresholdLabel,  "THRESHOLD", rustTerracotta);
    setupKnob (holdOffSlider,    holdOffLabel,    "HOLD-OFF",  rustTerracotta);
    setupKnob (filterFreqSlider, filterFreqLabel, "HP FILTER", rustTerracotta);

    // 2. Humanization Knobs
    setupKnob (timingShiftSlider, timingShiftLabel, "SHIFT",     goldenMustard);
    setupKnob (gainVarSlider,     gainVarLabel,     "GAIN VAR",  goldenMustard);
    setupKnob (panVarSlider,      panVarLabel,      "PAN VAR",   goldenMustard);
    setupKnob (pitchVarSlider,    pitchVarLabel,    "PITCH VAR", goldenMustard);
    setupKnob (amountSlider,      amountLabel,      "AMOUNT",    goldenMustard);

    // 3. Real-Time Visualizer Views
    addAndMakeVisible (transientScope);
    addAndMakeVisible (hitHistoryMatrix);

    // 3. Trap Roll Controls
    setupKnob (rollChanceSlider,   rollChanceLabel,   "CHANCE",      trapPlum);
    setupKnob (rollHitsSlider,     rollHitsLabel,     "HITS",        trapPlum);
    setupKnob (rollPitchSlider,    rollPitchLabel,    "PITCH SLIDE", trapPlum);
    setupKnob (rollDynamicsSlider, rollDynamicsLabel, "VELOCITY",    trapPlum);

    rollRateBox.addItemList (juce::StringArray { "1/16", "1/24T", "1/32", "1/48T", "1/64" }, 1);
    addAndMakeVisible (rollRateBox);

    rollRateLabel.setText ("RATE", juce::dontSendNotification);
    rollRateLabel.setFont (juce::FontOptions (10.0f).withStyle ("Bold"));
    rollRateLabel.setJustificationType (juce::Justification::centred);
    rollRateLabel.setColour (juce::Label::textColourId, juce::Colour (0xff3b291d));
    addAndMakeVisible (rollRateLabel);

    rollNowButton.setButtonText ("ROLL NOW");
    rollNowButton.setColour (juce::TextButton::textColourOffId, juce::Colour (0xff2b1b11));
    rollNowButton.onClick = [this] { audioProcessor.triggerManualRoll(); };
    addAndMakeVisible (rollNowButton);

    // 4. Output Knobs
    setupKnob (dryWetSlider,     dryWetLabel,     "DRY / WET", vintageOlive);
    setupKnob (outputGainSlider, outputGainLabel, "OUTPUT",    vintageOlive);

    // Attachments
    auto& apvts = audioProcessor.getAPVTS();
    thresholdAttachment   = std::make_unique<SliderAttachment> (apvts, "threshold",   thresholdSlider);
    holdOffAttachment     = std::make_unique<SliderAttachment> (apvts, "holdOff",     holdOffSlider);
    filterFreqAttachment  = std::make_unique<SliderAttachment> (apvts, "filterFreq",  filterFreqSlider);
    timingShiftAttachment = std::make_unique<SliderAttachment> (apvts, "timingShift", timingShiftSlider);
    gainVarAttachment     = std::make_unique<SliderAttachment> (apvts, "gainVar",     gainVarSlider);
    panVarAttachment      = std::make_unique<SliderAttachment> (apvts, "panVar",      panVarSlider);
    pitchVarAttachment    = std::make_unique<SliderAttachment> (apvts, "pitchVar",    pitchVarSlider);
    amountAttachment      = std::make_unique<SliderAttachment> (apvts, "amount",      amountSlider);

    rollChanceAttachment   = std::make_unique<SliderAttachment> (apvts, "rollChance",   rollChanceSlider);
    rollRateAttachment     = std::make_unique<ComboBoxAttachment> (apvts, "rollRate",   rollRateBox);
    rollHitsAttachment     = std::make_unique<SliderAttachment> (apvts, "rollHits",     rollHitsSlider);
    rollPitchAttachment    = std::make_unique<SliderAttachment> (apvts, "rollPitch",    rollPitchSlider);
    rollDynamicsAttachment = std::make_unique<SliderAttachment> (apvts, "rollDynamics", rollDynamicsSlider);

    dryWetAttachment      = std::make_unique<SliderAttachment> (apvts, "dryWet",      dryWetSlider);
    outputGainAttachment  = std::make_unique<SliderAttachment> (apvts, "outputGain",  outputGainSlider);

    // Clickable Author Link
    authorLink.setButtonText ("Made by Franco Benedetti | Benebeats.com");
    authorLink.setURL (juce::URL ("https://benebeats.com"));
    authorLink.setFont (juce::FontOptions (11.0f).withStyle ("Bold"), false);
    authorLink.setColour (juce::HyperlinkButton::textColourId, juce::Colour (0xff7a593e));
    addAndMakeVisible (authorLink);

    // Preset Buttons
    savePresetButton.setButtonText ("SAVE PRESET");
    savePresetButton.setColour (juce::TextButton::textColourOffId, juce::Colour (0xff2b1b11));
    savePresetButton.onClick = [this] { savePresetToFile(); };
    addAndMakeVisible (savePresetButton);

    loadPresetButton.setButtonText ("LOAD PRESET");
    loadPresetButton.setColour (juce::TextButton::textColourOffId, juce::Colour (0xff2b1b11));
    loadPresetButton.onClick = [this] { loadPresetFromFile(); };
    addAndMakeVisible (loadPresetButton);

    // 30 FPS animation timer
    startTimerHz (30);

    setSize (980, 500);
}

HatHumanizerAudioProcessorEditor::~HatHumanizerAudioProcessorEditor()
{
    setLookAndFeel (nullptr);
    thresholdSlider.setLookAndFeel (nullptr);
    holdOffSlider.setLookAndFeel (nullptr);
    filterFreqSlider.setLookAndFeel (nullptr);
    timingShiftSlider.setLookAndFeel (nullptr);
    gainVarSlider.setLookAndFeel (nullptr);
    panVarSlider.setLookAndFeel (nullptr);
    pitchVarSlider.setLookAndFeel (nullptr);
    amountSlider.setLookAndFeel (nullptr);
    rollChanceSlider.setLookAndFeel (nullptr);
    rollHitsSlider.setLookAndFeel (nullptr);
    rollPitchSlider.setLookAndFeel (nullptr);
    rollDynamicsSlider.setLookAndFeel (nullptr);
    dryWetSlider.setLookAndFeel (nullptr);
    outputGainSlider.setLookAndFeel (nullptr);
}

void HatHumanizerAudioProcessorEditor::setupKnob (juce::Slider& slider, juce::Label& label,
                                                  const juce::String& text, const juce::Colour& accentColor)
{
    slider.setLookAndFeel (&customLnf);
    slider.setSliderStyle (juce::Slider::RotaryVerticalDrag);
    slider.setTextBoxStyle (juce::Slider::TextBoxBelow, false, 60, 16);
    slider.setColour (juce::Slider::rotarySliderFillColourId, accentColor);
    addAndMakeVisible (slider);

    label.setText (text, juce::dontSendNotification);
    label.setFont (juce::FontOptions (10.0f).withStyle ("Bold"));
    label.setJustificationType (juce::Justification::centred);
    label.setColour (juce::Label::textColourId, juce::Colour (0xff3b291d));
    addAndMakeVisible (label);
}

void HatHumanizerAudioProcessorEditor::savePresetToFile()
{
    fileChooser = std::make_unique<juce::FileChooser> (
        "Save HatHumanizer Preset",
        juce::File::getSpecialLocation (juce::File::userDocumentsDirectory),
        "*.xml");

    fileChooser->launchAsync (juce::FileBrowserComponent::saveMode | juce::FileBrowserComponent::canSelectFiles | juce::FileBrowserComponent::warnAboutOverwriting,
        [this] (const juce::FileChooser& fc)
        {
            auto file = fc.getResult();
            if (file != juce::File())
            {
                auto state = audioProcessor.getAPVTS().copyState();
                std::unique_ptr<juce::XmlElement> xml (state.createXml());
                if (xml != nullptr)
                    xml->writeTo (file);
            }
        });
}

void HatHumanizerAudioProcessorEditor::loadPresetFromFile()
{
    fileChooser = std::make_unique<juce::FileChooser> (
        "Load HatHumanizer Preset",
        juce::File::getSpecialLocation (juce::File::userDocumentsDirectory),
        "*.xml");

    fileChooser->launchAsync (juce::FileBrowserComponent::openMode | juce::FileBrowserComponent::canSelectFiles,
        [this] (const juce::FileChooser& fc)
        {
            auto file = fc.getResult();
            if (file != juce::File() && file.existsAsFile())
            {
                auto xml = juce::XmlDocument::parse (file);
                if (xml != nullptr && xml->hasTagName (audioProcessor.getAPVTS().state.getType()))
                {
                    audioProcessor.getAPVTS().replaceState (juce::ValueTree::fromXml (*xml));
                }
            }
        });
}

//==============================================================================
void HatHumanizerAudioProcessorEditor::timerCallback()
{
    const bool hit = audioProcessor.consumeHitTriggered();
    if (hit)
    {
        hitLedBrightness = 1.0f;
        repaint (hitLedBounds.toNearestInt().expanded (8));
    }
    else if (hitLedBrightness > 0.01f)
    {
        hitLedBrightness *= 0.84f;
        if (hitLedBrightness < 0.01f)
            hitLedBrightness = 0.0f;

        repaint (hitLedBounds.toNearestInt().expanded (8));
    }

    transientScope.update (hit);
    hitHistoryMatrix.update (hit);
}

//==============================================================================
void HatHumanizerAudioProcessorEditor::paint (juce::Graphics& g)
{
    // 1. Outer Toasted Walnut Chassis
    juce::ColourGradient chassisGrad (juce::Colour (0xff342217), 0, 0,
                                      juce::Colour (0xff1e130c), 0, (float)getHeight(), false);
    g.setGradientFill (chassisGrad);
    g.fillAll();

    // 2. Vintage Cream Faceplate
    auto faceplate = getLocalBounds().reduced (6).toFloat();
    juce::ColourGradient plateGrad (juce::Colour (0xffede4d1), faceplate.getX(), faceplate.getY(),
                                    juce::Colour (0xffdfcfb5), faceplate.getX(), faceplate.getBottom(), false);
    g.setGradientFill (plateGrad);
    g.fillRoundedRectangle (faceplate, 9.0f);

    g.setColour (juce::Colour (0xffaa9374));
    g.drawRoundedRectangle (faceplate, 9.0f, 1.5f);

    // 3. Vintage Corner Screws
    auto drawScrew = [&g] (float cx, float cy)
    {
        const float r = 5.0f;
        juce::ColourGradient screwGrad (juce::Colour (0xffd6be96), cx - r, cy - r,
                                        juce::Colour (0xff735b3c), cx + r, cy + r, false);
        g.setGradientFill (screwGrad);
        g.fillEllipse (cx - r, cy - r, r * 2.0f, r * 2.0f);
        g.setColour (juce::Colour (0xff4f3a24));
        g.drawEllipse (cx - r, cy - r, r * 2.0f, r * 2.0f, 0.8f);

        const float slot = r * 1.3f;
        const float dx = std::cos (0.7f) * slot * 0.5f;
        const float dy = std::sin (0.7f) * slot * 0.5f;
        g.setColour (juce::Colour (0xff2b1f13));
        g.drawLine (cx - dx, cy - dy, cx + dx, cy + dy, 1.4f);
    };

    drawScrew (faceplate.getX() + 14.0f, faceplate.getY() + 14.0f);
    drawScrew (faceplate.getRight() - 14.0f, faceplate.getY() + 14.0f);
    drawScrew (faceplate.getX() + 14.0f, faceplate.getBottom() - 14.0f);
    drawScrew (faceplate.getRight() - 14.0f, faceplate.getBottom() - 14.0f);

    // 4. Header Banner
    g.setColour (juce::Colour (0xff2b1b11));
    g.setFont (juce::FontOptions (22.0f).withStyle ("Bold"));
    g.drawText ("HAT HUMANIZER", 32, 13, 260, 24, juce::Justification::left);

    g.setColour (juce::Colour (0xffba9f7d));
    g.drawHorizontalLine (64, faceplate.getX() + 16.0f, faceplate.getRight() - 16.0f);
    g.setColour (juce::Colour (0xfff5eedf));
    g.drawHorizontalLine (65, faceplate.getX() + 16.0f, faceplate.getRight() - 16.0f);

    // 5. Section Cards
    auto drawCard = [&g] (juce::Rectangle<int> rect, const juce::String& title, const juce::Colour& ribbonColor)
    {
        auto r = rect.toFloat();

        g.setColour (juce::Colour (0xfff4ecdc));
        g.fillRoundedRectangle (r, 8.0f);
        g.setColour (juce::Colour (0xffc4b195));
        g.drawRoundedRectangle (r, 8.0f, 1.2f);

        auto ribbon = juce::Rectangle<float> (r.getX(), r.getY(), r.getWidth(), 28.0f);
        juce::Path ribbonPath;
        ribbonPath.addRoundedRectangle (ribbon.getX(), ribbon.getY(), ribbon.getWidth(), ribbon.getHeight(), 8.0f, 8.0f, true, true, false, false);
        g.setColour (ribbonColor);
        g.fillPath (ribbonPath);

        g.setColour (juce::Colour (0xfffcf8ee));
        g.setFont (juce::FontOptions (11.5f).withStyle ("Bold"));
        g.drawText (title, (int)ribbon.getX() + 12, (int)ribbon.getY() + 5, (int)ribbon.getWidth() - 24, 18, juce::Justification::left);

        g.setColour (juce::Colour (0x30000000));
        g.drawHorizontalLine ((int)ribbon.getBottom(), ribbon.getX(), ribbon.getRight());
    };

    const int contentY = 74;
    const int contentHeight = 408;

    // Card 1: DETECTION (Width: 206)
    juce::Rectangle<int> detectCard (16, contentY, 206, contentHeight);
    drawCard (detectCard, "DETECTION", juce::Colour (0xffb84826));

    // Card 2: HUMAN GROOVE (Width: 320)
    juce::Rectangle<int> humanCard (detectCard.getRight() + 10, contentY, 320, contentHeight);
    drawCard (humanCard, "HUMAN GROOVE", juce::Colour (0xffcb8016));

    // Card 3: TRAP ROLLS (Width: 270)
    juce::Rectangle<int> rollCard (humanCard.getRight() + 10, contentY, 270, contentHeight);
    drawCard (rollCard, "TRAP ROLLS", juce::Colour (0xff94384a));

    // Card 4: MASTER OUTPUT (Width: 126)
    juce::Rectangle<int> outputCard (rollCard.getRight() + 10, contentY, getWidth() - rollCard.getRight() - 26, contentHeight);
    drawCard (outputCard, "OUTPUT", juce::Colour (0xff566b42));

    // 6. Vintage Amber Pilot Lamp
    hitLedBounds = juce::Rectangle<float> ((float)(detectCard.getRight() - 38), (float)(detectCard.getY() + 6), 16.0f, 16.0f);
    auto lampCenter = hitLedBounds.getCentre();
    const float lampRadius = 8.0f;

    juce::ColourGradient bezelGrad (juce::Colour (0xffd8bb78), lampCenter.x - lampRadius, lampCenter.y - lampRadius,
                                    juce::Colour (0xff7a5924), lampCenter.x + lampRadius, lampCenter.y + lampRadius, false);
    g.setGradientFill (bezelGrad);
    g.fillEllipse (hitLedBounds.expanded (2.5f));
    g.setColour (juce::Colour (0xff473111));
    g.drawEllipse (hitLedBounds.expanded (2.5f), 1.0f);

    if (hitLedBrightness > 0.05f)
    {
        g.setColour (juce::Colour (0xffffa012).withAlpha (hitLedBrightness * 0.55f));
        g.fillEllipse (hitLedBounds.expanded (6.0f * hitLedBrightness));
    }

    juce::Colour coldAmber (0xff573108);
    juce::Colour litAmber  (0xffffc233);
    juce::Colour currentAmber = coldAmber.interpolatedWith (litAmber, hitLedBrightness);

    juce::ColourGradient lensGrad (currentAmber.brighter (0.35f), lampCenter.x - lampRadius * 0.4f, lampCenter.y - lampRadius * 0.4f,
                                   currentAmber.darker (0.5f),   lampCenter.x + lampRadius * 0.4f, lampCenter.y + lampRadius * 0.4f, true);
    g.setGradientFill (lensGrad);
    g.fillEllipse (hitLedBounds);

    g.setColour (juce::Colours::white.withAlpha (0.3f + hitLedBrightness * 0.4f));
    g.fillEllipse (lampCenter.x - lampRadius * 0.5f, lampCenter.y - lampRadius * 0.5f, lampRadius * 0.5f, lampRadius * 0.35f);

    g.setColour (juce::Colour (0xfffaeedd));
    g.setFont (juce::FontOptions (9.5f).withStyle ("Bold"));
    g.drawText ("BEAT", (int)hitLedBounds.getX() - 32, (int)hitLedBounds.getY() - 1, 30, 18, juce::Justification::right);
}

void HatHumanizerAudioProcessorEditor::resized()
{
    // Header controls
    authorLink.setBounds (32, 38, 320, 18);
    savePresetButton.setBounds (getWidth() - 235, 20, 98, 26);
    loadPresetButton.setBounds (getWidth() - 130, 20, 98, 26);

    const int contentY = 74;
    const int labelHeight = 14;

    // 1. Detection Card (x: 16, width: 206)
    const int detectRow1Y = contentY + 36;
    const int detectRow2Y = 214;

    thresholdSlider.setBounds (24, detectRow1Y, 82, 82);
    thresholdLabel.setBounds  (20, detectRow1Y + 82, 90, labelHeight);

    holdOffSlider.setBounds (122, detectRow1Y, 82, 82);
    holdOffLabel.setBounds  (118, detectRow1Y + 82, 90, labelHeight);

    const int filterKnobSize = 82;
    const int filterX = 16 + (206 - filterKnobSize) / 2;
    filterFreqSlider.setBounds (filterX, detectRow2Y, filterKnobSize, filterKnobSize);
    filterFreqLabel.setBounds  (filterX - 8, detectRow2Y + filterKnobSize, filterKnobSize + 16, labelHeight);

    // Mini Real-Time Transient Scope
    transientScope.setBounds (24, 328, 190, 142);

    // 2. Humanization Card (x: 232, width: 320)
    const int humanRow1Y = contentY + 36;
    const int knobStd = 74;

    const int col1X = 242;
    const int col2X = 345;
    const int col3X = 448;

    timingShiftSlider.setBounds (col1X, humanRow1Y, knobStd, knobStd);
    timingShiftLabel.setBounds  (col1X - 6, humanRow1Y + knobStd, knobStd + 12, labelHeight);

    gainVarSlider.setBounds (col2X, humanRow1Y, knobStd, knobStd);
    gainVarLabel.setBounds  (col2X - 6, humanRow1Y + knobStd, knobStd + 12, labelHeight);

    panVarSlider.setBounds (col3X, humanRow1Y, knobStd, knobStd);
    panVarLabel.setBounds  (col3X - 6, humanRow1Y + knobStd, knobStd + 12, labelHeight);

    const int humanRow2Y = 214;
    const int row2Col1X = 294;
    const int row2Col2X = 396;

    pitchVarSlider.setBounds (row2Col1X, humanRow2Y, 76, 76);
    pitchVarLabel.setBounds  (row2Col1X - 6, humanRow2Y + 76, 88, labelHeight);

    amountSlider.setBounds (row2Col2X, humanRow2Y, 76, 76);
    amountLabel.setBounds  (row2Col2X - 6, humanRow2Y + 76, 88, labelHeight);

    // 8-Hit Groove History Matrix
    hitHistoryMatrix.setBounds (240, 328, 304, 142);

    // 3. Trap Rolls Card (x: 562, width: 270)
    const int rollRow1Y = contentY + 36;
    const int rollRow2Y = 214;

    const int rCol1X = 574;
    const int rCol2X = 660;
    const int rCol3X = 746;

    rollChanceSlider.setBounds (rCol1X, rollRow1Y, knobStd, knobStd);
    rollChanceLabel.setBounds  (rCol1X - 6, rollRow1Y + knobStd, knobStd + 12, labelHeight);

    // Rate Box in top row center
    rollRateLabel.setBounds (rCol2X, rollRow1Y + 8, knobStd, labelHeight);
    rollRateBox.setBounds   (rCol2X + 2, rollRow1Y + 28, knobStd - 4, 24);

    rollHitsSlider.setBounds (rCol3X, rollRow1Y, knobStd, knobStd);
    rollHitsLabel.setBounds  (rCol3X - 6, rollRow1Y + knobStd, knobStd + 12, labelHeight);

    rollPitchSlider.setBounds (600, rollRow2Y, 76, 76);
    rollPitchLabel.setBounds  (594, rollRow2Y + 76, 88, labelHeight);

    rollDynamicsSlider.setBounds (720, rollRow2Y, 76, 76);
    rollDynamicsLabel.setBounds  (714, rollRow2Y + 76, 88, labelHeight);

    // "ROLL NOW" momentary trigger button
    rollNowButton.setBounds (562 + (270 - 130) / 2, 382, 130, 32);

    // 4. Output Card (x: 842, width: 122)
    const int outputX = 842;
    const int outKnobX = outputX + (122 - 76) / 2;

    dryWetSlider.setBounds (outKnobX, humanRow1Y, 76, 76);
    dryWetLabel.setBounds  (outKnobX - 6, humanRow1Y + 76, 88, labelHeight);

    outputGainSlider.setBounds (outKnobX, humanRow2Y, 76, 76);
    outputGainLabel.setBounds  (outKnobX - 6, humanRow2Y + 76, 88, labelHeight);
}
