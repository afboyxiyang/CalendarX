//
//  SettingsView.swift
//  CalendarX
//
//  Created by zm on 2022/1/26.
//

import SwiftUI
import Combine
import CalendarXShared

struct SettingsView: View {
    
    @ObservedObject
    var viewModel: SettingsViewModel

    var body: some View {
        
        VStack(spacing: 15) {

            TitleView {
                Text( L10n.Settings.title).onTapGesture {
                    Router.backMain()
                }
            } leftItems: {
                EmptyView()
            } rightItems: {
                ScacleImageButton(image: .quit, action: viewModel.exit)
            }

            Section {
                appearanceRow
                calendarRow
                languageRow
                memubarRow
                autoRow
                launchRow
                recommendRow
                aboutRow
            }

            
        }
        .frame(height: .mainHeight, alignment: .top)

    }

}

extension SettingsView {
    
    var appearanceRow: some View {
        SettingsRow(title: L10n.Settings.appearance, detail: {}, action: Router.toAppearanceSettings)
    }
    
    var calendarRow: some View {
        SettingsRow(title:  L10n.Settings.calendar, detail: {}, action: Router.toCalendarSettings)
    }

    var languageRow: some View {
        SettingsPickerRow(title: L10n.Settings.language,
                           items: Language.allCases, width: 70,
                           selection:  $viewModel.language) { Text($0.title) }
    }

    var memubarRow: some View {
        SettingsRow(title: L10n.Settings.menubarStyle,
                    detail: {Text(viewModel.menubarStyle.title) },
                    action: Router.toMenubarSettings)
    }
    
    var launchRow: some View {
        AppToggle { Text(L10n.Settings.launchAtLogin).font(.title3) }
            .checkboxStyle()
    }

    
    @ViewBuilder
    var autoRow: some View {
        
        let isOn = Binding(get: viewModel.getNotificationStatut, set:  viewModel.setNotificationStatut)

        Toggle(isOn: isOn) { Text(L10n.Settings.auto).font(.title3) }
            .checkboxStyle()
        
    }
    
    var recommendRow: some View {
        SettingsRow(title: L10n.Settings.recommendations, detail: {}, action: Router.toRecommendations)
    }
    
    var aboutRow: some View {
        SettingsRow(title: L10n.Settings.about, detail: {}, action: Router.toAbout)
    }
    
}


extension SettingsView {
    
    var versionRow: some View {
        Group {
            Text(L10n.Settings.version) + Text(Updater.version)
        }
        .font(.footnote)
        .appForeground(.accentColor)
    }
}

struct SettingsRow<Content: View>: View {
    
    let title: LocalizedStringKey, showArrow: Bool
    
    @ViewBuilder
    let detail: () -> Content
    
    let action: VoidClosure
    
    init(title: LocalizedStringKey,
         showArrow: Bool = true,
         @ViewBuilder detail: @escaping () -> Content,
         action: @escaping VoidClosure) {
        self.title = title
        self.showArrow = showArrow
        self.detail = detail
        self.action = action
    }
    
    var body: some View {
        
        HStack {
            Text(title)
                .font(.title3)
            Spacer()
            
            Group {
                detail()
                if showArrow {
                    Image.rightArrow.font(.title3)
                }
            }
            .appForeground(.appSecondary)

        }
        .contentShape(.rect)
        .onTapGesture(perform: action)
        
    }
}

struct SettingsPickerRow<Item: Hashable, Label: View>: View {
    
    let title: LocalizedStringKey, items: [Item], width: CGFloat
    
    @Binding
    var selection: Item
    
    @ViewBuilder
    let itemLabel: (Item) -> Label
    
    @State
    private var isPresented = false
    
    private let pref = Preference.shared
    
    init(title: LocalizedStringKey,
         items: [Item],
         width: CGFloat = .popoverWidth,
         selection: Binding<Item>,
         @ViewBuilder itemLabel:  @escaping (Item) -> Label) {
        self.title = title
        self.items = items
        self.width = width
        self._selection = selection
        self.itemLabel = itemLabel
    }
    
    var body: some View {
        
        HStack {
            Text(title).font(.title3)
            Spacer()
            ScacleButtonPicker(items: items,
                               tint: pref.color,
                               width: width,
                               locale: pref.locale,
                               colorScheme: pref.colorScheme,
                               selection: $selection,
                               isPresented: $isPresented,
                               label: {
                HStack {
                    itemLabel(selection).appForeground(.appSecondary)
                    RotationArrow(isPresented: $isPresented)
                }
            }, itemLabel: itemLabel)
        }
    }
}

