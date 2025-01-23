//
//  AuthenticationManager.swift
//  FinalProject
//
//  Created by Apple on 23.01.25.
//


import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol AuthenticationManagerProtocol {
    func loginUser(email: String, password: String) async throws -> AuthDataResultModel
    func createUser(email: String, password: String) async throws -> AuthDataResultModel
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel
    func getCurrentUser() -> AuthDataResultModel?
    func signOut() throws
}

final class AuthenticationManager: AuthenticationManagerProtocol {
    
    let userManager: UserManagerProtocol
    
    init(usermanager: UserManagerProtocol = UserManager()) {
        self.userManager = usermanager
    }
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func loginUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    @MainActor
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                do {
                    let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
                    let authResult = try await self.signIn(credential: credential)
                    
                    if !(try await Firestore.firestore().collection("users").document(authResult.uid).getDocument().exists) {
                        try await self.userManager.saveUserToFirestore(
                            uid: authResult.uid,
                            email: authResult.email ?? "jonDoe@gmail.com",
                            fullname: "jon Doe",
                            username: "joniko"
                        )
                    }
                    continuation.resume(returning: authResult)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func getCurrentUser() -> AuthDataResultModel? {
        guard let user = Auth.auth().currentUser else { return nil }
        return AuthDataResultModel(user: user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
