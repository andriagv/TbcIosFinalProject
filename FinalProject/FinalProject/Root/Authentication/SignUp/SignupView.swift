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
    
    var formIsValid: Bool {
        !fullName.isEmpty && !userName.isEmpty && !email.isEmpty && !fullName.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
    }
    
    private func getError(for type: ValidationError) -> String? {
        errors.first { $0 == type }?.errorDescription
    }
    
    var body: some View {
        VStack {
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
                    VStack(spacing: 10) {
                        InputView(text: $fullName, title: "Full Name", placeholder: "Your full name")
                            .autocapitalization(.none)
                        if let error = getError(for: .fullName) ?? getError(for: .fullNameEmpty) {
                            Text(error).foregroundColor(.red).font(.system(size: 14))
                        }
                        
                        InputView(text: $userName, title: "Username", placeholder: "Your username")
                            .autocapitalization(.none)
                        if let error = getError(for: .username) ?? getError(for: .usernameEmpty) {
                            Text(error).foregroundColor(.red).font(.system(size: 14))
                        }
                        
                        InputView(text: $email, title: "Email", placeholder: "Your email address")
                            .autocapitalization(.none)
                        if let error = getError(for: .email) ?? getError(for: .emailEmpty) {
                            Text(error).foregroundColor(.red).font(.system(size: 14))
                        }
                        
                        InputView(text: $password, title: "Enter Password", placeholder: "Enter your Password", isSecureField: true)
                            .padding(.top, 7)
                        if let error = getError(for: .password) ?? getError(for: .passwordEmpty) {
                            Text(error).foregroundColor(.red).font(.system(size: 14))
                        }
                        
                        InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "Enter your Password", isSecureField: true)
                            .padding(.top, 7)
                        if let error = getError(for: .confirmPassword) ?? getError(for: .confirmPasswordEmpty) {
                            Text(error).foregroundColor(.red).font(.system(size: 14))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    Button(action: {
                        handleSignUp()
                    }) {
                        Text("Sign Up")
                    }
                    .padding(.horizontal, 20)
                    .makeButtonStyle(tintColor: .white, backgroundColor: Color.red, width: UIScreen.main.bounds.width - 40, height: 64)
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                }
                .padding(.bottom, 20)
            }
            .scrollIndicators(.hidden)
        }
        .background(.pageBack)
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

#Preview {
    SignupView()
}
