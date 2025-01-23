//
//  EditProfileViewModel.swift
//  FinalProject
//
//  Created by Apple on 23.01.25.
//


import SwiftUI
import FirebaseAuth

final class EditProfileViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var username = ""
    @Published var currentPassword = ""
    @Published var newPassword = ""
    @Published var confirmPassword = ""
    @Published var selectedImage: UIImage?
    @Published var showImagePicker = false
    @Published var isLoading = false
    @Published var error: Error?
    
    private let userManager: UserManagerProtocol
    private var authManager: AuthenticationManagerProtocol
    
    init(userManager: UserManagerProtocol = UserManager(),
         authManager: AuthenticationManagerProtocol = AuthenticationManager()) {
        self.userManager = userManager
        self.authManager = authManager
        
        Task {
            await loadUserData()
        }
    }
    
    @MainActor
    private func loadUserData() async {
        guard let userId = UserDefaultsManager.shared.getUserId() else { return }
        
        do {
            let user = try await userManager.getUser(by: userId)
            self.fullName = user.fullName
            self.username = user.username
        } catch {
            self.error = error
        }
    }
    
    @MainActor
    func updateProfile() async -> Bool {
        isLoading = true
        defer { isLoading = false }
        
        guard let userId = UserDefaultsManager.shared.getUserId() else { return false }
        
        do {
            try await userManager.updateUserFullnameAndUsername(
                uid: userId,
                fullname: fullName,
                username: username,
                imageUrl: nil
            )
            return true
        } catch {
            self.error = error
            return false
        }
    }
    
    @MainActor
    func updatePassword() async -> Bool {
        isLoading = true
        defer { isLoading = false }
        
        guard newPassword == confirmPassword else {
            error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Passwords do not match".localized()])
            return false
        }
        
        do {
            guard let email = Auth.auth().currentUser?.email else { return false }
            let _ = try await authManager.loginUser(email: email, password: currentPassword)
            try await Auth.auth().currentUser?.updatePassword(to: newPassword)
            return true
        } catch {
            self.error = error
            return false
        }
    }
}
