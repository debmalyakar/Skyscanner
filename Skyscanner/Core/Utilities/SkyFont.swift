//
//  SkyFont.swift
//  Skyscanner
//
//  Every font used in the app, in one place, applied with one view modifier.
//  Standalone: no dependencies on the other Skyscanner files (iOS 16+).
//
//  Usage:
//      Text("Forecast").skyFont(.screenTitle)
//      Text("24°").skyFont(.temperatureHero)
//      Text("HOURLY FORECAST").skyFont(.overline)              // includes its letter-spacing
//      Image(systemName: "clock").skyIcon(.pt12)               // SF Symbol sizes
//
//  Where you need a plain `Font` value instead of a modifier (Swift Charts labels,
//  AxisValueLabel, Text concatenation):
//      .font(SkyTextStyle.chartValue.font)
//
//  Where you need a UIFont (UITabBarAppearance, UIKit):
//      SkyTextStyle.tabLabel.uiFont
//
//  Design note: the Figma-style board specifies Outfit (numerals and titles) and DM Sans
//  (body). In the app they are stood in for by SF Pro Rounded (`.rounded`) and SF Pro.
//  To switch to custom fonts later, change `font` and `uiFont` below and nothing else.
//

import SwiftUI
import UIKit

// MARK: - Text styles

enum SkyTextStyle: CaseIterable {

    // MARK: Display numerals and titles (SF Pro Rounded, stands in for Outfit)

    /// 136 ultra-light rounded, -5 tracking. Today: the big temperature.
    case temperatureHero
    /// 42 ultra-light rounded. Places: temperature on each place card.
    case temperatureCard
    /// 34 medium rounded. Screen titles: "Forecast", "Places".
    case screenTitle
    /// 26 regular rounded. Today: condition under the temperature; wind, humidity and UV values.
    case conditionTitle
    /// 22 medium rounded. City name in the Today header and on Places cards.
    case cityName
    /// 22 regular rounded. Sunrise and sunset times.
    case sunTime
    /// 18 medium rounded. Hourly strip temperatures.
    case hourTemp
    /// 17 medium rounded. Daily list: high temperature.
    case tempHigh
    /// 17 regular rounded. Daily list: low temperature.
    case tempLow
    /// 13 medium rounded. Value labels on the chart points and bars.
    case chartValue

    // MARK: Text (SF Pro, stands in for DM Sans)

    /// 17 semibold. Search result names, "No places yet".
    case headline
    /// 16 semibold. Daily list day names, rain alert title, error messages.
    case bodyStrong
    /// 16 regular. Search field text.
    case body
    /// 15 regular. Today "H / L / Feels like" line, short status messages.
    case subhead
    /// 15 medium. Unselected segment in the Temperature / Rain / Wind control.
    case subheadMedium
    /// 15 semibold. Selected segment, "Try again" buttons.
    case subheadStrong
    /// 14 semibold. "Track" button.
    case button
    /// 14 regular. Forecast header subtitle.
    case subtitle
    /// 13 regular. Secondary lines: header subtitles, card captions, rain alert detail.
    case caption
    /// 13 medium. Stat units, hourly time labels.
    case captionMedium
    /// 13 semibold. Rain % in the daily list, the "Now" hourly label.
    case captionStrong
    /// 12 regular. Attribution lines, list footers, small notices.
    case footnote
    /// 12 medium. Chart weekday labels, wind chart caption.
    case footnoteMedium
    /// 12 semibold, +0.96 tracking. Card headers ("HOURLY FORECAST", "SUNRISE AND SUNSET").
    case overline
    /// 11 semibold. Tab bar labels.
    case tabLabel
    /// 11 regular. Forecast screen attribution.
    case micro

    // MARK: Specification

    private var spec: (size: CGFloat, weight: Font.Weight, design: Font.Design) {
        switch self {
        case .temperatureHero: return (136, .ultraLight, .rounded)
        case .temperatureCard: return (42,  .ultraLight, .rounded)
        case .screenTitle:     return (34,  .medium,     .rounded)
        case .conditionTitle:  return (26,  .regular,    .rounded)
        case .cityName:        return (22,  .medium,     .rounded)
        case .sunTime:         return (22,  .regular,    .rounded)
        case .hourTemp:        return (18,  .medium,     .rounded)
        case .tempHigh:        return (17,  .medium,     .rounded)
        case .tempLow:         return (17,  .regular,    .rounded)
        case .chartValue:      return (13,  .medium,     .rounded)

        case .headline:        return (17,  .semibold,   .default)
        case .bodyStrong:      return (16,  .semibold,   .default)
        case .body:            return (16,  .regular,    .default)
        case .subhead:         return (15,  .regular,    .default)
        case .subheadMedium:   return (15,  .medium,     .default)
        case .subheadStrong:   return (15,  .semibold,   .default)
        case .button:          return (14,  .semibold,   .default)
        case .subtitle:        return (14,  .regular,    .default)
        case .caption:         return (13,  .regular,    .default)
        case .captionMedium:   return (13,  .medium,     .default)
        case .captionStrong:   return (13,  .semibold,   .default)
        case .footnote:        return (12,  .regular,    .default)
        case .footnoteMedium:  return (12,  .medium,     .default)
        case .overline:        return (12,  .semibold,   .default)
        case .tabLabel:        return (11,  .semibold,   .default)
        case .micro:           return (11,  .regular,    .default)
        }
    }

    var size: CGFloat { spec.size }
    var weight: Font.Weight { spec.weight }
    var design: Font.Design { spec.design }

    /// Letter-spacing in points.
    var tracking: CGFloat {
        switch self {
        case .temperatureHero: return -5
        case .overline:        return 0.96      // 0.08em at 12pt
        default:               return 0
        }
    }

    /// The Dynamic Type category this style scales with when scaling is switched on.
    var relativeTo: Font.TextStyle {
        switch self {
        case .temperatureHero, .temperatureCard, .screenTitle:
            return .largeTitle
        case .conditionTitle, .cityName, .sunTime:
            return .title2
        case .hourTemp, .tempHigh, .tempLow, .headline, .bodyStrong, .body:
            return .body
        case .subhead, .subheadMedium, .subheadStrong, .button, .subtitle:
            return .subheadline
        case .caption, .captionMedium, .captionStrong, .chartValue, .footnote, .footnoteMedium:
            return .footnote
        case .overline, .tabLabel, .micro:
            return .caption2
        }
    }

    // MARK: Fonts

    /// A SwiftUI `Font` for this style, for the places a modifier can't be used.
    var font: Font {
        .system(size: size, weight: weight, design: design)
    }

    /// A `UIFont` for this style (UIKit and UITabBarAppearance).
    var uiFont: UIFont {
        let base = UIFont.systemFont(ofSize: size, weight: weight.uiKit)
        guard design == .rounded, let descriptor = base.fontDescriptor.withDesign(.rounded) else {
            return base
        }
        return UIFont(descriptor: descriptor, size: size)
    }
}

private extension Font.Weight {
    var uiKit: UIFont.Weight {
        switch self {
        case .ultraLight: return .ultraLight
        case .thin:       return .thin
        case .light:      return .light
        case .regular:    return .regular
        case .medium:     return .medium
        case .semibold:   return .semibold
        case .bold:       return .bold
        case .heavy:      return .heavy
        case .black:      return .black
        default:          return .regular
        }
    }
}

// MARK: - The view modifier

struct SkyFontModifier: ViewModifier {
    private let style: SkyTextStyle
    private let scales: Bool
    @ScaledMetric private var scaledSize: CGFloat

    init(style: SkyTextStyle, scales: Bool) {
        self.style = style
        self.scales = scales
        _scaledSize = ScaledMetric(wrappedValue: style.size, relativeTo: style.relativeTo)
    }

    func body(content: Content) -> some View {
        content
            .font(.system(size: scales ? scaledSize : style.size, weight: style.weight, design: style.design))
            .tracking(style.tracking)
    }
}

extension View {
    /// Applies one of the app's text styles (size, weight, design and tracking together).
    ///
    /// `scales` lets the text grow with the user's Dynamic Type setting. It is off by default
    /// because several layouts use fixed heights (48pt list rows, the 150pt sun card, 88pt place
    /// cards) that would clip larger text. Turn it on per screen once those heights are relaxed.
    func skyFont(_ style: SkyTextStyle, scales: Bool = false) -> some View {
        modifier(SkyFontModifier(style: style, scales: scales))
    }
}

// MARK: - SF Symbol sizes (icons are fonts too, so they're listed here as well)

enum SkyIconSize: CGFloat, CaseIterable {
    case pt11 = 11   // drop.fill beside the rain % in the daily list
    case pt12 = 12   // clock in the hourly header
    case pt13 = 13   // location.fill on the current-location place card
    case pt14 = 14   // sunrise.fill in the sun card header
    case pt15 = 15   // magnifyingglass in the search bar
    case pt18 = 18   // header buttons, stat card icons, sunrise / sunset footer icons
    case pt20 = 20   // umbrella in the rain alert; the "+" in the Places header (semibold)
    case pt22 = 22   // tab bar icons, daily list and hourly weather icons
    case pt24 = 24   // plus / checkmark circle on search results
    case pt26 = 26   // weather icon on place cards
    case pt28 = 28   // empty-state and error-state icons
    case pt84 = 84   // the big weather icon in the Today hero
}

extension View {
    /// Sizes an SF Symbol (`Image(systemName:)`).
    func skyIcon(_ size: SkyIconSize, weight: Font.Weight = .regular) -> some View {
        font(.system(size: size.rawValue, weight: weight))
    }
}

// MARK: - Type specimen preview (scroll to check every style)

#if DEBUG
#Preview("Type specimen") {
    ScrollView {
        VStack(alignment: .leading, spacing: 18) {
            ForEach(SkyTextStyle.allCases, id: \.self) { style in
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(String(describing: style))  ·  \(Int(style.size))pt")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundStyle(Color.white.opacity(0.7))

                    Text(style == .overline ? "HOURLY FORECAST"
                         : (style.design == .rounded ? "24° 17:05" : "Partly Cloudy in Lisbon"))
                        .skyFont(style)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                }
            }
        }
        .padding(20)
    }
    .background(Color(red: 0x1A / 255, green: 0x56 / 255, blue: 0xAD / 255))
}
#endif
