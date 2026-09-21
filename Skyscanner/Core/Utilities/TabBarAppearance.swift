//
//  TabBarAppearance.swift
//  Skyscanner
//
//  Created by debmalyakar on 20/09/26.
//

import Foundation
import SwiftUI


enum SkyTabPalette {
    /// Sun #FFC933
    static let selected = Color(red: 1.0, green: 0xC9 / 255, blue: 0x33 / 255)
    /// White at 88%
    static let unselected = Color.white.opacity(0.88)

    static let uiSelected = UIColor(red: 1.0, green: 0xC9 / 255, blue: 0x33 / 255, alpha: 1)
    static let uiUnselected = UIColor(white: 1, alpha: 0.88)
}



enum SkyTabBarAppearance {
    /// Call once at launch, e.g. in your App's `init()`.
    ///
    /// On iOS 26 and later the system draws its own floating glass tab bar, so the
    /// background and border below may not show there. The icon and label colors still apply.
    static func apply() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(white: 1, alpha: 0.06)
        appearance.shadowColor = UIColor(white: 1, alpha: 0.12)          // the 1pt top border

        func style(_ item: UITabBarItemAppearance) {
            let font = UIFont.systemFont(ofSize: 11, weight: .semibold)

            item.normal.iconColor = SkyTabPalette.uiUnselected
            item.normal.titleTextAttributes = [
                .foregroundColor: SkyTabPalette.uiUnselected,
                .font: font
            ]

            item.selected.iconColor = SkyTabPalette.uiSelected
            item.selected.titleTextAttributes = [
                .foregroundColor: SkyTabPalette.uiSelected,
                .font: font
            ]
        }

        style(appearance.stackedLayoutAppearance)          // iPhone portrait
        style(appearance.inlineLayoutAppearance)           // iPhone landscape
        style(appearance.compactInlineLayoutAppearance)

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

enum SkyTab: String, CaseIterable, Identifiable {
    case today, forecast, conditions, places

    var id: String { rawValue }

    var title: String {
        switch self {
        case .today:      return "Today"
        case .forecast:   return "Forecast"
        case .conditions: return "Conditions"
        case .places:     return "Places"
        }
    }

    /// Base symbol names. Today and Conditions have `.fill` versions; the bar switches
    /// to them when the tab is selected (sun.max.fill, square.grid.2x2.fill).
    /// `calendar` and `mappin.and.ellipse` have no fill version and stay outlined.
    var symbol: String {
        switch self {
        case .today:      return "sun.max"
        case .forecast:   return "calendar"
        case .conditions: return "square.grid.2x2"
        case .places:     return "mappin.and.ellipse"
        }
    }

    /// For option B: use inside `.tabItem { SkyTab.today.label }`.
    var label: some View {
        Label(title, systemImage: symbol)
    }
}
