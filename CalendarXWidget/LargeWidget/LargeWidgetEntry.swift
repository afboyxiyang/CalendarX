//
//  LargeWidgetEntry.swift
//  CalendarXWidget
//
//  Created by zm on 2023/12/8.
//

import WidgetKit
import CalendarXShared
import SwiftUI

struct LargeWidgetEntry: TimelineEntry {
    let date: Date, configuration: LargeWidgetProvider.Intent

    init(date: Date = Date(), configuration: LargeWidgetProvider.Intent = .init()) {
        self.date = date
        self.configuration = configuration
    }
}

extension LargeWidgetEntry {
    
    private var palettes: [String] {
        ["C72C41", "F07B3F", "E0C341", "03C988", "1363DF", "876445", "7858A6"]
    }

    var tint: Color {
        guard configuration.tint.rawValue > 0 else { return Color(hex: palettes[0], alpha: 1) }
        return Color(hex: palettes[configuration.tint.rawValue - 1], alpha: 1)
    }

    var colorScheme: ColorScheme? {
        Theme(rawValue: configuration.theme.rawValue - 1)?.colorScheme
    }

    var locale: Locale {
        Language(rawValue: configuration.language.rawValue - 1)?.locale ?? .current
    }

    var firstWeekday: AppWeekday {
        AppWeekday(rawValue: configuration.startWeekOn.rawValue) ?? .sunday
    }
}

extension LargeWidgetEntry {
    var showLunar: Bool {
        configuration.showLunar?.boolValue ?? true
    }

    var showEvents: Bool {
        configuration.showEvents?.boolValue ?? true
    }

    var showHolidays: Bool {
        configuration.showHolidays?.boolValue ?? true
    }
}
