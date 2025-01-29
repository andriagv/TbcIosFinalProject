//
//  LoginView.swift
//  FinalProject
//
//  Created by Apple on 23.01.25.
//


import SwiftUI
import Foundation

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var showToast = false
    @State private var showErrorToast = false
    
    var formIsValid: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                logoSection
                Spacer()
                inputSection
                signUpSection
                Spacer()
                buttonSection
            }
            .padding()
            .background(.pageBack)
        }
    }
    
    private var logoSection: some View {
        Image("darkLogo")
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: 233)
            .overlay {
                if showToast {
                    ToastView(message: "logged in successfully")
                        .transition(
                            .move(edge: .top)
                            .combined(with: .opacity)
                            .combined(with: .scale(scale: 0.8))
                        )
                        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                        .zIndex(1)
                        .padding(.top, 10)
                } else if showErrorToast {
                    ToastView(message: "email or pasword is wrong", bgColor: Color.red)
                        .transition(
                            .move(edge: .top)
                            .combined(with: .opacity)
                            .combined(with: .scale(scale: 0.8))
                        )
                        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                        .zIndex(1)
                        .padding(.top, 10)
                }
            }
    }
    
    private var inputSection: some View {
        VStack(spacing: 24) {
            InputView(text: $email,
                      title: "Email",
                      placeholder: "Your email address")
            .autocapitalization(.none)
            
            InputView(text: $password,
                      title: "Password",
                      placeholder: "Enter your Password",
                      isSecureField: true)
        }
        .padding(.horizontal)
    }
    
    private var signUpSection: some View {
        NavigationLink {
            SignupView()
        } label: {
            HStack(spacing: 3) {
                Text("New Account?")
                    .font(.system(size: 12))
                Spacer()
                Text("Sign Up")
                    .fontWeight(.bold)
                    .font(.system(size: 18))
            }
        }
        .foregroundStyle(.customText)
        .padding()
    }
    
    private var buttonSection: some View {
        VStack(spacing: 10) {
            googleSignInButton
            emailSignInButton
        }
        .padding(.top, 24)
    }
    
    private var googleSignInButton: some View {
        Button {
            Task {
                do {
                    try await viewModel.signInGoogle()
                    withAnimation {
                        showToast = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first {
                            window.rootViewController = TabBarController()
                        }
                    }
                } catch {
                    print(error)
                }
            }
        } label: {
            HStack {
                Image("Google")
                Text("Continue with Google")
                    .fontWeight(.semibold)
                    .makeTextStyle(color: .gray, size: 20)
            }
            .makeButtonStyle(tintColor: Color.red, backgroundColor: .white.opacity(0.95), width: UIScreen.main.bounds.width - 40, height: 64)
            .shadow(color: .gray.opacity(0.5), radius: 2)
        }
    }
    
    private var emailSignInButton: some View {
        Button {
            Task {
                let response = await viewModel.signIn(email: email, password: password)
                if response {
                    withAnimation {
                        showToast = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first {
                            window.rootViewController = TabBarController()
                        }
                    }
                } else {
                    showErrorToast = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showErrorToast = false
                    }
                }
            }
        } label: {
            HStack {
                Text("Log In")
                    .fontWeight(.semibold)
                    .font(.system(size: 20))
            }
            .frame(maxWidth: .infinity)
        }
        .makeButtonStyle(tintColor: .white, backgroundColor: Color.blue, width: UIScreen.main.bounds.width - 40, height: 64)
        .disabled(!formIsValid)
        .opacity(formIsValid ? 0.9 : 0.5)
    }
}

#Preview {
    LoginView()
}
