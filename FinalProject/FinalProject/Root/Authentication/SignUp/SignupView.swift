//
//  SignupView.swift
//  FinalProject
//
//  Created by Apple on 23.01.25.
//


import SwiftUI

struct SignupView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var fullName = ""
    @State private var userName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @StateObject private var viewModel = SignupViewModel()
    @State private var errors: [ValidationError] = []
    @State private var showToast = false
    @State private var showErrorToast = false
    
    private func getError(for type: ValidationError) -> String? {
        errors.first { $0 == type }?.errorDescription
    }
    
    var body: some View {
        VStack {
            // Navigation Bar
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 20))
                        .foregroundColor(Color.secondary)
                }
                Spacer()
                Text("Sign up")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.customPageTitle)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .navigationBarHidden(true)
            .overlay {
                if showToast {
                    ToastView(message: "signup in successfully")
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .zIndex(1)
                } else if showErrorToast {
                    ToastView(message: "wrong", bgColor: .red)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .zIndex(1)
                }
            }
            
            ScrollView {
                VStack(spacing: 20) {
                    // Input Fields
                    VStack(spacing: 10) {
                        // Full Name
                        InputView(text: $fullName, title: "Full Name", placeholder: "Your full name")
                            .autocapitalization(.none)
                        if let error = getError(for: .fullName) ?? getError(for: .fullNameEmpty) {
                            Text(error).foregroundColor(.red).font(.system(size: 14))
                        }
                        
                        // Username
                        InputView(text: $userName, title: "Username", placeholder: "Your username")
                            .autocapitalization(.none)
                        if let error = getError(for: .username) ?? getError(for: .usernameEmpty) {
                            Text(error).foregroundColor(.red).font(.system(size: 14))
                        }
                        
                        // Email
                        InputView(text: $email, title: "Email", placeholder: "Your email address")
                            .autocapitalization(.none)
                        if let error = getError(for: .email) ?? getError(for: .emailEmpty) {
                            Text(error).foregroundColor(.red).font(.system(size: 14))
                        }
                        
                        // Password
                        InputView(text: $password, title: "Enter Password", placeholder: "Enter your Password", isSecureField: true)
                            .padding(.top, 7)
                        if let error = getError(for: .password) ?? getError(for: .passwordEmpty) {
                            Text(error).foregroundColor(.red).font(.system(size: 14))
                        }
                        
                        // Confirm Password
                        InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "Enter your Password", isSecureField: true)
                            .padding(.top, 7)
                        if let error = getError(for: .confirmPassword) ?? getError(for: .confirmPasswordEmpty) {
                            Text(error).foregroundColor(.red).font(.system(size: 14))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Sign Up Button
                    Button(action: {
                        handleSignUp()
                    }) {
                        Text("Sign Up")
                            .fontWeight(.semibold)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 64)
                            .background(.separator)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 20)
            }
            .scrollIndicators(.hidden)
        }
        //.background(.customBackground)
    }
    
    private func handleSignUp() {
        errors = viewModel.validateFields(
            fullName: fullName,
            userName: userName,
            email: email,
            password: password,
            confirmPassword: confirmPassword
        )
        
        if errors.isEmpty {
            Task {
                let response = await viewModel.signUp(
                    email: email,
                    password: password,
                    fullName: fullName,
                    userName: userName,
                    confirmPassword: confirmPassword
                )
                
                if response {
                    withAnimation {
                        showToast = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first {
                            window.rootViewController = TabBarController()
                        }
                    }
                } else {
                    showErrorToast = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showErrorToast = false
                    }
                }
            }
        }
    }
}

//#Preview {
//    SignupView()
//}
