/*
  ==============================================================================

    PluginEditor.h
    HatHumanizer - Modern UI Editor Header with Trap Roll Generator

  ==============================================================================
*/

#pragma once

#include <JuceHeader.h>
#include "PluginProcessor.h"

//==============================================================================
class CustomKnobLookAndFeel : public juce::LookAndFeel_V4
{
public:
    CustomKnobLookAndFeel();

    void drawRotarySlider (juce::Graphics& g, int x, int y, int width, int height,
                           float sliderPosProportional, float rotaryStartAngle,
                           float rotaryEndAngle, juce::Slider& slider) override;

    juce::Label* createSliderTextBox (juce::Slider& slider) override;
    void drawComboBox (juce::Graphics& g, int width, int height, bool isButtonDown,
                       int buttonX, int buttonY, int buttonW, int buttonH, juce::ComboBox& box) override;
    void drawButtonBackground (juce::Graphics& g, juce::Button& button, const juce::Colour& backgroundColour,
                               bool shouldDrawButtonAsHighlighted, bool shouldDrawButtonAsDown) override;
};

//==============================================================================
class TransientScopeView : public juce::Component
{
public:
    TransientScopeView (HatHumanizerAudioProcessor& p) : processor (p) {}

    void update (bool isTriggered)
    {
        processor.getScopeSnapshot (scopeData, bufferSize, thresholdLinear);
        if (isTriggered)
            flashBrightness = 1.0f;
        else
            flashBrightness *= 0.82f;

        repaint();
    }

    void paint (juce::Graphics& g) override
    {
        auto bounds = getLocalBounds().toFloat();

        // 1. Brass / Bakelite outer bezel
        juce::ColourGradient bezelGrad (juce::Colour (0xffb5955c), bounds.getX(), bounds.getY(),
                                        juce::Colour (0xff543b18), bounds.getRight(), bounds.getBottom(), false);
        g.setGradientFill (bezelGrad);
        g.fillRoundedRectangle (bounds, 6.0f);
        g.setColour (juce::Colour (0xff38240d));
        g.drawRoundedRectangle (bounds, 6.0f, 1.2f);

        // 2. Dark CRT Phosphor Screen (Inset)
        auto screen = bounds.reduced (3.5f);
        juce::ColourGradient crtGrad (juce::Colour (0xff1c150b), screen.getCentreX(), screen.getY(),
                                      juce::Colour (0xff0e0b06), screen.getCentreX(), screen.getBottom(), false);
        g.setGradientFill (crtGrad);
        g.fillRoundedRectangle (screen, 4.0f);

        // 3. Oscilloscope Reticle Grid
        g.setColour (juce::Colour (0x28d4a34b));
        const float midY = screen.getY() + screen.getHeight() * 0.74f;
        g.drawHorizontalLine (static_cast<int>(midY), screen.getX() + 4.0f, screen.getRight() - 4.0f);

        // Grid divisions
        for (int i = 1; i <= 3; ++i)
        {
            float gridY = screen.getY() + screen.getHeight() * (0.18f * (float)i);
            g.drawHorizontalLine (static_cast<int>(gridY), screen.getX() + 4.0f, screen.getRight() - 4.0f);
        }
        for (int i = 1; i <= 5; ++i)
        {
            float gridX = screen.getX() + screen.getWidth() * (0.166f * (float)i);
            g.drawVerticalLine (static_cast<int>(gridX), screen.getY() + 4.0f, screen.getBottom() - 4.0f);
        }

        // Header Title in Screen
        g.setColour (juce::Colour (0x90d4b882));
        g.setFont (juce::FontOptions (8.0f).withStyle ("Bold"));
        g.drawText ("TRANSIENT SCOPE", (int)screen.getX() + 6, (int)screen.getY() + 3, 100, 10, juce::Justification::left);

        // 4. Threshold Line
        const float thrY = midY - juce::jlimit (0.0f, 1.0f, thresholdLinear) * (screen.getHeight() * 0.65f);
        g.setColour (juce::Colour (0xccd97706));
        const float dashLengths[] = { 4.0f, 3.0f };
        juce::Line<float> thrLine (screen.getX() + 4.0f, thrY, screen.getRight() - 4.0f, thrY);
        g.drawDashedLine (thrLine, dashLengths, 2, 1.0f);

        g.setFont (juce::FontOptions (8.0f).withStyle ("Bold"));
        g.setColour (juce::Colour (0xffebb654));
        g.drawText ("THR", static_cast<int>(screen.getRight() - 24), static_cast<int>(thrY - 10), 20, 10, juce::Justification::right);

        // 5. Signal Waveform Curve
        juce::Path wavePath;
        juce::Path fillPath;
        const float w = screen.getWidth() - 8.0f;
        const float startX = screen.getX() + 4.0f;

        wavePath.startNewSubPath (startX, midY);
        fillPath.startNewSubPath (startX, midY);

        for (int i = 0; i < bufferSize; ++i)
        {
            const float x = startX + (static_cast<float>(i) / static_cast<float>(bufferSize - 1)) * w;
            const float val = juce::jlimit (0.0f, 1.0f, scopeData[i]);
            const float y = midY - val * (screen.getHeight() * 0.65f);
            wavePath.lineTo (x, y);
            fillPath.lineTo (x, y);
        }
        fillPath.lineTo (screen.getRight() - 4.0f, midY);
        fillPath.closeSubPath();

        // Waveform fill
        g.setColour (juce::Colour (0x1fe8bd68));
        g.fillPath (fillPath);

        // Waveform glow & stroke
        g.setColour (juce::Colour (0xfff0c86e));
        g.strokePath (wavePath, juce::PathStrokeType (1.5f, juce::PathStrokeType::curved, juce::PathStrokeType::rounded));

        // 6. Flash / Transient Indicator
        if (flashBrightness > 0.05f)
        {
            g.setColour (juce::Colour (0xffffd766).withAlpha (flashBrightness * 0.38f));
            g.fillRoundedRectangle (screen, 4.0f);

            auto badgeRect = juce::Rectangle<float> (screen.getRight() - 34.0f, screen.getY() + 3.0f, 28.0f, 11.0f);
            g.setColour (juce::Colour (0xd0b84826));
            g.fillRoundedRectangle (badgeRect, 2.0f);
            g.setColour (juce::Colour (0xfffff4db));
            g.setFont (juce::FontOptions (8.0f).withStyle ("Bold"));
            g.drawText ("HIT", badgeRect, juce::Justification::centred);
        }

        // Screen bezel highlight
        g.setColour (juce::Colours::white.withAlpha (0.06f));
        g.drawLine (screen.getX(), screen.getY() + 1.0f, screen.getRight(), screen.getY() + 1.0f, 1.0f);
    }

private:
    HatHumanizerAudioProcessor& processor;
    static constexpr int bufferSize = 256;
    float scopeData[bufferSize] = { 0.0f };
    float thresholdLinear = 0.1f;
    float flashBrightness = 0.0f;
};

//==============================================================================
class HitHistoryMatrixView : public juce::Component
{
public:
    enum class ViewMode
    {
        All = 0,
        Pitch,
        Gain,
        Pan
    };

    HitHistoryMatrixView (HatHumanizerAudioProcessor& p) : processor (p) {}

    void update (bool isTriggered)
    {
        processor.getHitHistorySnapshot (history, 8);
        if (isTriggered)
            pulseIntensity = 1.0f;
        else
            pulseIntensity *= 0.85f;

        repaint();
    }

    void mouseMove (const juce::MouseEvent& e) override
    {
        bool overTab = false;
        for (int m = 0; m < 4; ++m)
        {
            if (modeTabs[m].contains (e.position))
            {
                overTab = true;
                break;
            }
        }
        setMouseCursor (overTab ? juce::MouseCursor::PointingHandCursor : juce::MouseCursor::NormalCursor);
    }

    void mouseDown (const juce::MouseEvent& e) override
    {
        for (int m = 0; m < 4; ++m)
        {
            if (modeTabs[m].contains (e.position))
            {
                currentMode = static_cast<ViewMode>(m);
                repaint();
                return;
            }
        }
    }

    static juce::String formatPan (float panVal)
    {
        if (panVal < -0.05f)
            return juce::String::formatted ("L %.0f%%", -panVal * 100.0f);
        if (panVal > 0.05f)
            return juce::String::formatted ("R %.0f%%", panVal * 100.0f);
        return "CTR";
    }

    void paint (juce::Graphics& g) override
    {
        auto bounds = getLocalBounds().toFloat();

        // 1. Brass / Bakelite Frame
        juce::ColourGradient bezelGrad (juce::Colour (0xffb5955c), bounds.getX(), bounds.getY(),
                                        juce::Colour (0xff543b18), bounds.getRight(), bounds.getBottom(), false);
        g.setGradientFill (bezelGrad);
        g.fillRoundedRectangle (bounds, 6.0f);
        g.setColour (juce::Colour (0xff38240d));
        g.drawRoundedRectangle (bounds, 6.0f, 1.2f);

        // 2. Inset Screen / Panel
        auto panel = bounds.reduced (3.5f);
        juce::ColourGradient crtGrad (juce::Colour (0xff1c150b), panel.getCentreX(), panel.getY(),
                                      juce::Colour (0xff0e0b06), panel.getCentreX(), panel.getBottom(), false);
        g.setGradientFill (crtGrad);
        g.fillRoundedRectangle (panel, 4.0f);

        // Header Title
        g.setColour (juce::Colour (0xffd4b882));
        g.setFont (juce::FontOptions (8.5f).withStyle ("Bold"));
        g.drawText ("GROOVE MEMORY", (int)panel.getX() + 8, (int)panel.getY() + 3, 110, 12, juce::Justification::left);

        // 3. Interactive Mode Selector Tabs [ALL] [PITCH] [GAIN] [PAN]
        const float tabW = 33.0f;
        const float tabH = 12.0f;
        const float tabSpacing = 2.5f;
        const float tabStartX = panel.getRight() - 8.0f - (4.0f * tabW + 3.0f * tabSpacing);
        const float tabY = panel.getY() + 3.0f;
        const char* tabNames[4] = { "ALL", "PITCH", "GAIN", "PAN" };

        for (int m = 0; m < 4; ++m)
        {
            modeTabs[m] = juce::Rectangle<float> (tabStartX + m * (tabW + tabSpacing), tabY, tabW, tabH);
            const bool isSel = (currentMode == static_cast<ViewMode>(m));

            if (isSel)
            {
                g.setColour (juce::Colour (0xffd4a34b));
                g.fillRoundedRectangle (modeTabs[m], 2.5f);
                g.setColour (juce::Colour (0xff1a1106));
                g.setFont (juce::FontOptions (7.5f).withStyle ("Bold"));
                g.drawText (tabNames[m], modeTabs[m], juce::Justification::centred);
            }
            else
            {
                g.setColour (juce::Colour (0xff140e06));
                g.fillRoundedRectangle (modeTabs[m], 2.5f);
                g.setColour (juce::Colour (0x40d4a34b));
                g.drawRoundedRectangle (modeTabs[m], 2.5f, 0.8f);
                g.setColour (juce::Colour (0x90d4b882));
                g.setFont (juce::FontOptions (7.0f).withStyle ("Bold"));
                g.drawText (tabNames[m], modeTabs[m], juce::Justification::centred);
            }
        }

        // 4. Sub-header: Legend & Live Readout
        const float subY = panel.getY() + 17.0f;
        if (currentMode == ViewMode::All)
        {
            // Legend markers
            g.setFont (juce::FontOptions (7.5f).withStyle ("Bold"));

            // Pitch marker (Amber)
            g.setColour (juce::Colour (0xffffc233));
            g.fillEllipse (panel.getX() + 8.0f, subY + 2.0f, 6.0f, 6.0f);
            g.setColour (juce::Colour (0xffe6b85c));
            g.drawText ("PITCH", (int)panel.getX() + 17, (int)subY, 32, 10, juce::Justification::left);

            // Gain marker (Jade Green)
            g.setColour (juce::Colour (0xff2ec4b6));
            g.fillRect (panel.getX() + 55.0f, subY + 1.5f, 5.0f, 7.0f);
            g.setColour (juce::Colour (0xff2ec4b6));
            g.drawText ("GAIN", (int)panel.getX() + 63, (int)subY, 28, 10, juce::Justification::left);

            // Pan marker (Cyan)
            g.setColour (juce::Colour (0xff00d2ff));
            juce::Path dPath;
            dPath.addTriangle (panel.getX() + 99.0f, subY + 1.0f, panel.getX() + 95.0f, subY + 5.0f, panel.getX() + 99.0f, subY + 9.0f);
            dPath.addTriangle (panel.getX() + 99.0f, subY + 1.0f, panel.getX() + 103.0f, subY + 5.0f, panel.getX() + 99.0f, subY + 9.0f);
            g.fillPath (dPath);
            g.setColour (juce::Colour (0xff00d2ff));
            g.drawText ("PAN", (int)panel.getX() + 107, (int)subY, 26, 10, juce::Justification::left);
        }
        else if (currentMode == ViewMode::Pitch)
        {
            g.setFont (juce::FontOptions (7.5f).withStyle ("Bold"));
            g.setColour (juce::Colour (0xffffc233));
            g.fillEllipse (panel.getX() + 8.0f, subY + 2.0f, 6.0f, 6.0f);
            g.setColour (juce::Colour (0xffd4b882));
            g.drawText ("PITCH DEVIATION (+/- 50 CENTS)", (int)panel.getX() + 18, (int)subY, 180, 10, juce::Justification::left);
        }
        else if (currentMode == ViewMode::Gain)
        {
            g.setFont (juce::FontOptions (7.5f).withStyle ("Bold"));
            g.setColour (juce::Colour (0xff2ec4b6));
            g.fillRect (panel.getX() + 8.0f, subY + 1.5f, 6.0f, 7.0f);
            g.setColour (juce::Colour (0xffd4b882));
            g.drawText ("DYNAMICS VARIATION (+/- 6.0 dB)", (int)panel.getX() + 18, (int)subY, 180, 10, juce::Justification::left);
        }
        else // ViewMode::Pan
        {
            g.setFont (juce::FontOptions (7.5f).withStyle ("Bold"));
            g.setColour (juce::Colour (0xff00d2ff));
            juce::Path dPath;
            dPath.addTriangle (panel.getX() + 11.0f, subY + 1.0f, panel.getX() + 7.0f, subY + 5.0f, panel.getX() + 11.0f, subY + 9.0f);
            dPath.addTriangle (panel.getX() + 11.0f, subY + 1.0f, panel.getX() + 15.0f, subY + 5.0f, panel.getX() + 11.0f, subY + 9.0f);
            g.fillPath (dPath);
            g.setColour (juce::Colour (0xffd4b882));
            g.drawText ("STEREO FIELD SWING (LEFT / RIGHT)", (int)panel.getX() + 19, (int)subY, 180, 10, juce::Justification::left);
        }

        // 5. Grid & Plot Area
        const float chartY = panel.getY() + 30.0f;
        const float chartH = panel.getHeight() - 44.0f;
        const float cellW = (panel.getWidth() - 16.0f) / 8.0f;
        const float centerY = chartY + chartH * 0.5f;

        // Baseline (0 / neutral)
        g.setColour (juce::Colour (0x38d4a34b));
        g.drawHorizontalLine (static_cast<int>(centerY), panel.getX() + 8.0f, panel.getRight() - 8.0f);

        // Guide lines
        const float topGuideY = centerY - chartH * 0.38f;
        const float botGuideY = centerY + chartH * 0.38f;
        g.setColour (juce::Colour (0x15d4a34b));
        g.drawHorizontalLine (static_cast<int>(topGuideY), panel.getX() + 8.0f, panel.getRight() - 8.0f);
        g.drawHorizontalLine (static_cast<int>(botGuideY), panel.getX() + 8.0f, panel.getRight() - 8.0f);

        // Scale guide labels on left/right for single modes
        if (currentMode == ViewMode::Pitch)
        {
            g.setColour (juce::Colour (0x45d4b882));
            g.setFont (juce::FontOptions (6.5f));
            g.drawText ("+50c", (int)panel.getX() + 8, (int)topGuideY - 7, 24, 7, juce::Justification::left);
            g.drawText ("  0c", (int)panel.getX() + 8, (int)centerY - 4, 24, 7, juce::Justification::left);
            g.drawText ("-50c", (int)panel.getX() + 8, (int)botGuideY - 1, 24, 7, juce::Justification::left);
        }
        else if (currentMode == ViewMode::Gain)
        {
            g.setColour (juce::Colour (0x45d4b882));
            g.setFont (juce::FontOptions (6.5f));
            g.drawText ("+6dB", (int)panel.getX() + 8, (int)topGuideY - 7, 24, 7, juce::Justification::left);
            g.drawText (" 0dB", (int)panel.getX() + 8, (int)centerY - 4, 24, 7, juce::Justification::left);
            g.drawText ("-6dB", (int)panel.getX() + 8, (int)botGuideY - 1, 24, 7, juce::Justification::left);
        }
        else if (currentMode == ViewMode::Pan)
        {
            g.setColour (juce::Colour (0x45d4b882));
            g.setFont (juce::FontOptions (6.5f));
            g.drawText ("100% L", (int)panel.getX() + 8, (int)topGuideY - 7, 30, 7, juce::Justification::left);
            g.drawText (" CTR", (int)panel.getX() + 8, (int)centerY - 4, 30, 7, juce::Justification::left);
            g.drawText ("100% R", (int)panel.getX() + 8, (int)botGuideY - 1, 30, 7, juce::Justification::left);
        }

        // 6. DRAW CONTENT ACCORDING TO MODE

        //--------------------------------------------------------------------------
        // A) VIEW: ALL (Unified Multi-Indicator)
        //--------------------------------------------------------------------------
        if (currentMode == ViewMode::All)
        {
            // First pass: GAIN vertical bars (drawn in background)
            for (int i = 0; i < 8; ++i)
            {
                if (! history[i].active)
                    continue;

                const float cellCenterX = panel.getX() + 8.0f + static_cast<float>(i) * cellW + cellW * 0.5f;
                const float gainNorm = juce::jlimit (-1.0f, 1.0f, history[i].gainDb / 6.0f);
                const float barH = gainNorm * (chartH * 0.38f);
                const float ageAlpha = 1.0f - (static_cast<float>(i) / 10.0f);

                if (std::abs (barH) > 1.0f)
                {
                    const float topY = gainNorm >= 0.0f ? (centerY - barH) : centerY;
                    const float h = std::abs (barH);
                    auto barRect = juce::Rectangle<float> (cellCenterX - 3.5f, topY, 7.0f, h);

                    juce::Colour barCol = (gainNorm >= 0.0f) ? juce::Colour (0xff2ec4b6) : juce::Colour (0xffe05244);
                    g.setColour (barCol.withAlpha (0.45f * ageAlpha));
                    g.fillRoundedRectangle (barRect, 1.5f);
                    g.setColour (barCol.withAlpha (0.8f * ageAlpha));
                    g.drawRoundedRectangle (barRect, 1.5f, 0.7f);
                }
            }

            // Second pass: PAN path & markers
            juce::Path panPath;
            bool panStarted = false;
            for (int i = 0; i < 8; ++i)
            {
                if (! history[i].active)
                    break;
                const float cellCenterX = panel.getX() + 8.0f + static_cast<float>(i) * cellW + cellW * 0.5f;
                const float panNorm = juce::jlimit (-1.0f, 1.0f, history[i].pan);
                const float panY = centerY - panNorm * (chartH * 0.38f); // Left = top, Right = bottom

                if (! panStarted)
                {
                    panPath.startNewSubPath (cellCenterX, panY);
                    panStarted = true;
                }
                else
                {
                    panPath.lineTo (cellCenterX, panY);
                }
            }

            if (panStarted)
            {
                g.setColour (juce::Colour (0x5000d2ff));
                g.strokePath (panPath, juce::PathStrokeType (1.0f, juce::PathStrokeType::curved, juce::PathStrokeType::rounded));
            }

            for (int i = 0; i < 8; ++i)
            {
                if (! history[i].active)
                    continue;
                const float cellCenterX = panel.getX() + 8.0f + static_cast<float>(i) * cellW + cellW * 0.5f;
                const float panNorm = juce::jlimit (-1.0f, 1.0f, history[i].pan);
                const float panY = centerY - panNorm * (chartH * 0.38f);
                const float ageAlpha = 1.0f - (static_cast<float>(i) / 10.0f);

                juce::Path diamond;
                diamond.addTriangle (cellCenterX, panY - 3.5f, cellCenterX - 3.5f, panY, cellCenterX, panY + 3.5f);
                diamond.addTriangle (cellCenterX, panY - 3.5f, cellCenterX + 3.5f, panY, cellCenterX, panY + 3.5f);
                g.setColour (juce::Colour (0xff00d2ff).withAlpha (0.85f * ageAlpha));
                g.fillPath (diamond);
                g.setColour (juce::Colours::white.withAlpha (0.9f * ageAlpha));
                g.strokePath (diamond, juce::PathStrokeType (0.7f));
            }

            // Third pass: PITCH path & beads (foreground)
            juce::Path pitchPath;
            bool pitchStarted = false;
            for (int i = 0; i < 8; ++i)
            {
                if (! history[i].active)
                    break;
                const float cellCenterX = panel.getX() + 8.0f + static_cast<float>(i) * cellW + cellW * 0.5f;
                const float pitchNorm = juce::jlimit (-1.0f, 1.0f, history[i].pitchCents / 60.0f);
                const float pitchY = centerY - pitchNorm * (chartH * 0.38f);

                if (! pitchStarted)
                {
                    pitchPath.startNewSubPath (cellCenterX, pitchY);
                    pitchStarted = true;
                }
                else
                {
                    pitchPath.lineTo (cellCenterX, pitchY);
                }
            }

            if (pitchStarted)
            {
                g.setColour (juce::Colour (0x80ebb654));
                g.strokePath (pitchPath, juce::PathStrokeType (1.5f, juce::PathStrokeType::curved, juce::PathStrokeType::rounded));
            }

            for (int i = 0; i < 8; ++i)
            {
                const float cellCenterX = panel.getX() + 8.0f + static_cast<float>(i) * cellW + cellW * 0.5f;

                if (history[i].active)
                {
                    const float pitchNorm = juce::jlimit (-1.0f, 1.0f, history[i].pitchCents / 60.0f);
                    const float pitchY = centerY - pitchNorm * (chartH * 0.38f);
                    const float ageAlpha = 1.0f - (static_cast<float>(i) / 9.0f);
                    const float radius = 4.2f;

                    juce::Colour dotColor = (history[i].pitchCents >= 0.0f) ? juce::Colour (0xffffc233) : juce::Colour (0xffe07a33);

                    if (i == 0 && pulseIntensity > 0.05f)
                    {
                        g.setColour (dotColor.withAlpha (pulseIntensity * 0.55f));
                        g.fillEllipse (cellCenterX - radius * 2.2f, pitchY - radius * 2.2f, radius * 4.4f, radius * 4.4f);
                    }

                    juce::ColourGradient beadGrad (dotColor.brighter (0.4f), cellCenterX - radius * 0.35f, pitchY - radius * 0.35f,
                                                    dotColor.darker (0.3f),   cellCenterX + radius * 0.35f, pitchY + radius * 0.35f, true);
                    g.setGradientFill (beadGrad);
                    g.fillEllipse (cellCenterX - radius, pitchY - radius, radius * 2.0f, radius * 2.0f);

                    g.setColour (juce::Colour (0xff2d1d0c).withAlpha (ageAlpha));
                    g.drawEllipse (cellCenterX - radius, pitchY - radius, radius * 2.0f, radius * 2.0f, 0.8f);

                    g.setColour (juce::Colours::white.withAlpha (0.7f * ageAlpha));
                    g.fillEllipse (cellCenterX - radius * 0.4f, pitchY - radius * 0.4f, radius * 0.45f, radius * 0.4f);
                }
                else
                {
                    g.setColour (juce::Colour (0x25d4a34b));
                    g.fillEllipse (cellCenterX - 2.0f, centerY - 2.0f, 4.0f, 4.0f);
                }
            }
        }
        //--------------------------------------------------------------------------
        // B) VIEW: PITCH (Dedicated Pitch Display)
        //--------------------------------------------------------------------------
        else if (currentMode == ViewMode::Pitch)
        {
            juce::Path pPath, fillPath;
            bool started = false;
            float firstX = 0.0f, lastX = 0.0f;

            for (int i = 0; i < 8; ++i)
            {
                if (! history[i].active)
                    break;
                const float cellCenterX = panel.getX() + 8.0f + static_cast<float>(i) * cellW + cellW * 0.5f;
                const float pitchNorm = juce::jlimit (-1.0f, 1.0f, history[i].pitchCents / 60.0f);
                const float pitchY = centerY - pitchNorm * (chartH * 0.38f);

                if (! started)
                {
                    pPath.startNewSubPath (cellCenterX, pitchY);
                    fillPath.startNewSubPath (cellCenterX, centerY);
                    fillPath.lineTo (cellCenterX, pitchY);
                    firstX = cellCenterX;
                    started = true;
                }
                else
                {
                    pPath.lineTo (cellCenterX, pitchY);
                    fillPath.lineTo (cellCenterX, pitchY);
                }
                lastX = cellCenterX;
            }

            if (started)
            {
                fillPath.lineTo (lastX, centerY);
                fillPath.closeSubPath();
                g.setColour (juce::Colour (0x20ffc233));
                g.fillPath (fillPath);

                g.setColour (juce::Colour (0xfff0cb70));
                g.strokePath (pPath, juce::PathStrokeType (1.8f, juce::PathStrokeType::curved, juce::PathStrokeType::rounded));
            }

            for (int i = 0; i < 8; ++i)
            {
                const float cellCenterX = panel.getX() + 8.0f + static_cast<float>(i) * cellW + cellW * 0.5f;
                if (history[i].active)
                {
                    const float pitchNorm = juce::jlimit (-1.0f, 1.0f, history[i].pitchCents / 60.0f);
                    const float pitchY = centerY - pitchNorm * (chartH * 0.38f);
                    const float radius = 5.0f;
                    const float ageAlpha = 1.0f - (static_cast<float>(i) / 9.0f);

                    juce::Colour dotCol = (history[i].pitchCents >= 0.0f) ? juce::Colour (0xffffc233) : juce::Colour (0xffe07a33);
                    if (i == 0 && pulseIntensity > 0.05f)
                    {
                        g.setColour (dotCol.withAlpha (pulseIntensity * 0.6f));
                        g.fillEllipse (cellCenterX - radius * 2.2f, pitchY - radius * 2.2f, radius * 4.4f, radius * 4.4f);
                    }

                    g.setColour (dotCol.withAlpha (ageAlpha));
                    g.fillEllipse (cellCenterX - radius, pitchY - radius, radius * 2.0f, radius * 2.0f);
                    g.setColour (juce::Colours::white.withAlpha (0.8f * ageAlpha));
                    g.fillEllipse (cellCenterX - radius * 0.45f, pitchY - radius * 0.45f, radius * 0.5f, radius * 0.4f);

                    // Numerical pitch text
                    g.setColour (juce::Colour (0xffe8bd68).withAlpha (ageAlpha));
                    g.setFont (juce::FontOptions (7.0f).withStyle ("Bold"));
                    const float textY = (pitchNorm >= 0.0f) ? (pitchY - 11.0f) : (pitchY + 5.0f);
                    g.drawText (juce::String::formatted ("%+.0fc", history[i].pitchCents),
                                (int)cellCenterX - 14, (int)textY, 28, 8, juce::Justification::centred);
                }
                else
                {
                    g.setColour (juce::Colour (0x25d4a34b));
                    g.fillEllipse (cellCenterX - 2.0f, centerY - 2.0f, 4.0f, 4.0f);
                }
            }
        }
        //--------------------------------------------------------------------------
        // C) VIEW: GAIN (Dedicated Dynamics Display)
        //--------------------------------------------------------------------------
        else if (currentMode == ViewMode::Gain)
        {
            for (int i = 0; i < 8; ++i)
            {
                const float cellCenterX = panel.getX() + 8.0f + static_cast<float>(i) * cellW + cellW * 0.5f;

                if (history[i].active)
                {
                    const float gainNorm = juce::jlimit (-1.0f, 1.0f, history[i].gainDb / 6.0f);
                    const float barH = gainNorm * (chartH * 0.38f);
                    const float ageAlpha = 1.0f - (static_cast<float>(i) / 9.0f);

                    const float topY = gainNorm >= 0.0f ? (centerY - barH) : centerY;
                    const float h = std::max (2.0f, std::abs (barH));
                    auto barRect = juce::Rectangle<float> (cellCenterX - 5.5f, topY, 11.0f, h);

                    juce::Colour col = (gainNorm >= 0.0f) ? juce::Colour (0xff2ec4b6) : juce::Colour (0xffe05244);
                    juce::ColourGradient barGrad (col.brighter (0.3f), barRect.getCentreX(), barRect.getY(),
                                                    col.darker (0.2f),   barRect.getCentreX(), barRect.getBottom(), false);
                    g.setGradientFill (barGrad);
                    g.fillRoundedRectangle (barRect, 2.0f);

                    g.setColour (juce::Colours::white.withAlpha (0.4f * ageAlpha));
                    g.drawRoundedRectangle (barRect, 2.0f, 0.8f);

                    if (i == 0 && pulseIntensity > 0.05f)
                    {
                        g.setColour (col.withAlpha (pulseIntensity * 0.45f));
                        g.drawRoundedRectangle (barRect.expanded (2.0f), 3.0f, 1.5f);
                    }

                    // Numeric text
                    g.setColour (col.withAlpha (ageAlpha));
                    g.setFont (juce::FontOptions (7.0f).withStyle ("Bold"));
                    const float textY = (gainNorm >= 0.0f) ? (topY - 10.0f) : (topY + h + 2.0f);
                    g.drawText (juce::String::formatted ("%+.1f", history[i].gainDb),
                                (int)cellCenterX - 14, (int)textY, 28, 8, juce::Justification::centred);
                }
                else
                {
                    g.setColour (juce::Colour (0x25d4a34b));
                    g.fillEllipse (cellCenterX - 2.0f, centerY - 2.0f, 4.0f, 4.0f);
                }
            }
        }
        //--------------------------------------------------------------------------
        // D) VIEW: PAN (Dedicated Stereo Field Display)
        //--------------------------------------------------------------------------
        else // ViewMode::Pan
        {
            juce::Path pPath;
            bool started = false;

            for (int i = 0; i < 8; ++i)
            {
                if (! history[i].active)
                    break;
                const float cellCenterX = panel.getX() + 8.0f + static_cast<float>(i) * cellW + cellW * 0.5f;
                const float panNorm = juce::jlimit (-1.0f, 1.0f, history[i].pan);
                const float panY = centerY - panNorm * (chartH * 0.38f);

                if (! started)
                {
                    pPath.startNewSubPath (cellCenterX, panY);
                    started = true;
                }
                else
                {
                    pPath.lineTo (cellCenterX, panY);
                }
            }

            if (started)
            {
                g.setColour (juce::Colour (0xff00d2ff));
                g.strokePath (pPath, juce::PathStrokeType (1.5f, juce::PathStrokeType::curved, juce::PathStrokeType::rounded));
            }

            for (int i = 0; i < 8; ++i)
            {
                const float cellCenterX = panel.getX() + 8.0f + static_cast<float>(i) * cellW + cellW * 0.5f;
                if (history[i].active)
                {
                    const float panNorm = juce::jlimit (-1.0f, 1.0f, history[i].pan);
                    const float panY = centerY - panNorm * (chartH * 0.38f);
                    const float ageAlpha = 1.0f - (static_cast<float>(i) / 9.0f);

                    juce::Path diamond;
                    diamond.addTriangle (cellCenterX, panY - 4.5f, cellCenterX - 4.5f, panY, cellCenterX, panY + 4.5f);
                    diamond.addTriangle (cellCenterX, panY - 4.5f, cellCenterX + 4.5f, panY, cellCenterX, panY + 4.5f);

                    if (i == 0 && pulseIntensity > 0.05f)
                    {
                        g.setColour (juce::Colour (0xff00d2ff).withAlpha (pulseIntensity * 0.5f));
                        g.fillEllipse (cellCenterX - 8.0f, panY - 8.0f, 16.0f, 16.0f);
                    }

                    g.setColour (juce::Colour (0xff00d2ff).withAlpha (ageAlpha));
                    g.fillPath (diamond);
                    g.setColour (juce::Colours::white.withAlpha (0.9f * ageAlpha));
                    g.strokePath (diamond, juce::PathStrokeType (0.9f));

                    // Stereo wing line
                    g.setColour (juce::Colour (0x6000d2ff).withAlpha (ageAlpha));
                    g.drawLine (cellCenterX, centerY, cellCenterX, panY, 1.0f);

                    // Numeric text
                    g.setColour (juce::Colour (0xff80e5ff).withAlpha (ageAlpha));
                    g.setFont (juce::FontOptions (7.0f).withStyle ("Bold"));
                    const float textY = (panNorm >= 0.0f) ? (panY - 11.0f) : (panY + 5.0f);
                    g.drawText (formatPan (history[i].pan),
                                (int)cellCenterX - 16, (int)textY, 32, 8, juce::Justification::centred);
                }
                else
                {
                    g.setColour (juce::Colour (0x25d4a34b));
                    g.fillEllipse (cellCenterX - 2.0f, centerY - 2.0f, 4.0f, 4.0f);
                }
            }
        }

        // 7. Step Number Labels at Bottom (1 to 8)
        for (int i = 0; i < 8; ++i)
        {
            const float cellX = panel.getX() + 8.0f + static_cast<float>(i) * cellW;
            const float cellCenterX = cellX + cellW * 0.5f;

            // Slot vertical track
            g.setColour (juce::Colour (0x12d4a34b));
            g.drawLine (cellCenterX, chartY + 2.0f, cellCenterX, chartY + chartH - 2.0f, 1.0f);

            // Step number badge
            g.setColour (juce::Colour (i == 0 ? 0xffebb654 : 0x70d4b882));
            g.setFont (juce::FontOptions (7.5f).withStyle ("Bold"));
            g.drawText (juce::String (i + 1), static_cast<int>(cellX), static_cast<int>(panel.getBottom() - 11.0f), static_cast<int>(cellW), 10, juce::Justification::centred);
        }
    }

private:
    HatHumanizerAudioProcessor& processor;
    HatHumanizerAudioProcessor::HitRecord history[8];
    float pulseIntensity = 0.0f;
    ViewMode currentMode = ViewMode::All;
    juce::Rectangle<float> modeTabs[4];
};

//==============================================================================
class HatHumanizerAudioProcessorEditor  : public juce::AudioProcessorEditor,
                                          public juce::Timer
{
public:
    HatHumanizerAudioProcessorEditor (HatHumanizerAudioProcessor&);
    ~HatHumanizerAudioProcessorEditor() override;

    //==============================================================================
    void paint (juce::Graphics&) override;
    void resized() override;
    void timerCallback() override;

private:
    HatHumanizerAudioProcessor& audioProcessor;

    CustomKnobLookAndFeel customLnf;

    // 1. Detection Sliders
    juce::Slider thresholdSlider;
    juce::Slider holdOffSlider;
    juce::Slider filterFreqSlider;

    // 2. Humanization Sliders
    juce::Slider timingShiftSlider;
    juce::Slider gainVarSlider;
    juce::Slider panVarSlider;
    juce::Slider pitchVarSlider;
    juce::Slider amountSlider;

    // 3. Trap Roll Controls
    juce::Slider rollChanceSlider;
    juce::ComboBox rollRateBox;
    juce::Slider rollHitsSlider;
    juce::Slider rollPitchSlider;
    juce::Slider rollDynamicsSlider;
    juce::TextButton rollNowButton;

    // 4. Output Sliders
    juce::Slider dryWetSlider;
    juce::Slider outputGainSlider;

    // Labels
    juce::Label thresholdLabel;
    juce::Label holdOffLabel;
    juce::Label filterFreqLabel;
    juce::Label timingShiftLabel;
    juce::Label gainVarLabel;
    juce::Label panVarLabel;
    juce::Label pitchVarLabel;
    juce::Label amountLabel;
    juce::Label rollChanceLabel;
    juce::Label rollRateLabel;
    juce::Label rollHitsLabel;
    juce::Label rollPitchLabel;
    juce::Label rollDynamicsLabel;
    juce::Label dryWetLabel;
    juce::Label outputGainLabel;

    // Attachments
    using SliderAttachment = juce::AudioProcessorValueTreeState::SliderAttachment;
    using ComboBoxAttachment = juce::AudioProcessorValueTreeState::ComboBoxAttachment;

    std::unique_ptr<SliderAttachment> thresholdAttachment;
    std::unique_ptr<SliderAttachment> holdOffAttachment;
    std::unique_ptr<SliderAttachment> filterFreqAttachment;
    std::unique_ptr<SliderAttachment> timingShiftAttachment;
    std::unique_ptr<SliderAttachment> gainVarAttachment;
    std::unique_ptr<SliderAttachment> panVarAttachment;
    std::unique_ptr<SliderAttachment> pitchVarAttachment;
    std::unique_ptr<SliderAttachment> amountAttachment;

    std::unique_ptr<SliderAttachment> rollChanceAttachment;
    std::unique_ptr<ComboBoxAttachment> rollRateAttachment;
    std::unique_ptr<SliderAttachment> rollHitsAttachment;
    std::unique_ptr<SliderAttachment> rollPitchAttachment;
    std::unique_ptr<SliderAttachment> rollDynamicsAttachment;

    std::unique_ptr<SliderAttachment> dryWetAttachment;
    std::unique_ptr<SliderAttachment> outputGainAttachment;

    // User Preset Management
    juce::TextButton savePresetButton;
    juce::TextButton loadPresetButton;
    std::unique_ptr<juce::FileChooser> fileChooser;

    // Clickable Author Link
    juce::HyperlinkButton authorLink;

    // Visual Real-Time Components
    TransientScopeView transientScope;
    HitHistoryMatrixView hitHistoryMatrix;

    // Visual feedback for transient detector
    float hitLedBrightness = 0.0f;
    juce::Rectangle<float> hitLedBounds;

    void setupKnob (juce::Slider& slider, juce::Label& label, const juce::String& text, const juce::Colour& accentColor);
    void savePresetToFile();
    void loadPresetFromFile();

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (HatHumanizerAudioProcessorEditor)
};
