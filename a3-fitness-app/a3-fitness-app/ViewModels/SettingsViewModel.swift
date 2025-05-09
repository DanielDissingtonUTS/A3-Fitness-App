import Foundation

class SettingsViewModel: ObservableObject {
    private func unlockThemes(userLevel: Int, themes: inout [Theme]) { // `inout` allows themes to be modified
        for (index, theme) in themes.enumerated() {
            if userLevel >= theme.requiredLevel {
                themes[index].unlocked = true
            }
        }
    }
}
