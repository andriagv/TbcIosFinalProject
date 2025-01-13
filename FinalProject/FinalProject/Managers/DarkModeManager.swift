//
//  DarkModeManager.swift
//  FinalProject
//
//  Created by Apple on 12.01.25.
//

import UIKit

protocol ThemeManaging {
    var currentTheme: AppTheme { get }
    func saveTheme(_ theme: AppTheme)
    func applyTheme(to window: UIWindow?)
}

final class DarkModeManager: ThemeManaging {
    private let themeKey = "selectedTheme"
    static let shared = DarkModeManager()

    var currentTheme: AppTheme {
        let savedTheme = UserDefaults.standard.string(forKey: themeKey) ?? AppTheme.light.rawValue
        return AppTheme(rawValue: savedTheme) ?? .light
    }

    func saveTheme(_ theme: AppTheme) {
        UserDefaults.standard.set(theme.rawValue, forKey: themeKey)
    }

    func applyTheme(to window: UIWindow?) {
        guard let window = window else { return }
        switch currentTheme {
        case .light:
            window.overrideUserInterfaceStyle = .light
        case .dark:
            window.overrideUserInterfaceStyle = .dark
        }
    }
}

enum AppTheme: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
}
