//
//  LoginViewModel.swift
//  FinalProject
//
//  Created by Apple on 23.01.25.
//


import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
}

protocol LoginViewModelProtocol {
    func signIn(email: String, password: String) async -> Bool
    func signInGoogle() async throws
}

final class LoginViewModel: LoginViewModelProtocol, ObservableObject {
    private let authenticationManager: AuthenticationManagerProtocol
    private let userManager: UserManagerProtocol
    
    init(
        authenticationManager: AuthenticationManagerProtocol = AuthenticationManager(),
        userManager: UserManagerProtocol = UserManager()
    ) {
        self.authenticationManager = authenticationManager
        self.userManager = userManager
    }
    
    deinit {
        print("LoginViewModel deinitialized")
    }
    
    @MainActor
    func signInGoogle() async throws {
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }

        let accessToken = gidSignInResult.user.accessToken.tokenString
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken)
        
        let authResult = try await authenticationManager.signInWithGoogle(tokens: tokens)
        
        UserDefaultsManager.shared.setUserLoggedIn(userId: authResult.uid)
    }
    
    func signIn(email: String, password: String) async -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            print("Email or password is empty")
            return false
        }
        do {
            let result = try await authenticationManager.loginUser(email: email, password: password)
            UserDefaultsManager.shared.setUserLoggedIn(userId: result.uid)
            return true
        } catch {
            print("Error signing in: \(error)")
            return false
        }
    }
    
    func checkUserStatus() -> Bool {
        UserDefaultsManager.shared.isUserLoggedIn()
    }
}
