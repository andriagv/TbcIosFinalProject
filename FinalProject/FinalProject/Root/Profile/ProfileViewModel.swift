//
//  ProfileViewModel.swift
//  FinalProject
//
//  Created by Apple on 12.01.25.
//

import Foundation
import SwiftUI

final class ProfileViewModel: ObservableObject {
    @Published var user: UserModel?
    @Published var selectedTheme: AppTheme
    @Published var isLoading = false
    @Published var error: Error?
    
    private let userManager: UserManagerProtocol
    private let themeManager: ThemeManaging
    
    init(userManager: UserManagerProtocol = UserManager(),
         themeManager: ThemeManaging = DarkModeManager.shared) {
        self.userManager = userManager
        self.themeManager = themeManager
        self.selectedTheme = themeManager.currentTheme
        
        Task {
            await fetchUserData()
        }
    }
    
    func setTheme(_ theme: AppTheme, for window: UIWindow?) {
        self.selectedTheme = theme
        themeManager.saveTheme(theme)
        themeManager.applyTheme(to: window)
    }
    
    @MainActor
    func fetchUserData() async {
        isLoading = true
        defer { isLoading = false }
        
        guard let userId = UserDefaultsManager.shared.getUserId() else {
            error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])
            return
        }
        
        do {
            user = try await userManager.getUser(by: userId)
        } catch {
            self.error = error
        }
    }
    
    @MainActor
    func signOut() {
        UserDefaultsManager.shared.logoutUser()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UIHostingController(rootView: LoginView())
        }
    }
    
    @MainActor
    func updateUserProfile(fullname: String, username: String, image: UIImage?) async {
        isLoading = true
        defer { isLoading = false }
        
        guard let userId = UserDefaultsManager.shared.getUserId() else { return }
        
        do {
            var imageUrl: String?
            if let image = image {
                imageUrl = try await userManager.uploadProfileImage(image: image, userId: userId)
            }
            
            try await userManager.updateUserFullnameAndUsername(uid: userId, fullname: fullname, username: username, imageUrl: imageUrl)
            
            await fetchUserData()
        } catch {
            self.error = error
        }
    }
    
    func deleteAccount() async {
        guard let userId = UserDefaultsManager.shared.getUserId() else { return }
        do {
            try await userManager.deleteUser(uid: userId)
            await MainActor.run {
                signOut()
            }
        } catch {
            self.error = error
        }
    }
}
