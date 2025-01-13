//
//  ProfileViewModel.swift
//  FinalProject
//
//  Created by Apple on 12.01.25.
//

import SwiftUI

final class ProfileViewModel: ObservableObject {
    @Published var selectedTheme: AppTheme
    private let themeManager: ThemeManaging
    
    
    init(themeManager: ThemeManaging = DarkModeManager.shared) {
        self.themeManager = themeManager
        self.selectedTheme = themeManager.currentTheme
    }
    
    func setTheme(_ theme: AppTheme, for window: UIWindow?) {
        self.selectedTheme = theme
        themeManager.saveTheme(theme)
        themeManager.applyTheme(to: window)
    }
}

