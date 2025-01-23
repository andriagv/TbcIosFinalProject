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
        return !email.isEmpty && !password.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("darkLogo")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 233)
                    .overlay {
                        if showToast {
                            ToastView(message: "logged in successfully")
                                .transition(.move(edge: .top).combined(with: .opacity))
                                .zIndex(1)
                        } else if showErrorToast {
                            ToastView(message: "email or pasword is wrong", bgColor: Color.red)
                                .transition(.move(edge: .top).combined(with: .opacity))
                                .zIndex(1)
                        }
                    }
                Spacer()
                
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
                
                NavigationLink {
                    SignupView()
                } label: {
                    HStack(spacing: 3) {
                        Text("New Accountt?")
                            .font(.system(size: 12))
                        Spacer()
                        Text("Sign Up")
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                    }
                }
                .foregroundStyle(.customText)
                .padding()
                
                Spacer()
                
                VStack(spacing: 10) {
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
                        .makeButtonStyle(tintColor: Color.red, backgroundColor: .white, width: UIScreen.main.bounds.width - 40, height: 64)
                        .shadow(color: .gray.opacity(0.5), radius: 2)
                    }
                    
                    Button {
                        Task {
                            let response = await viewModel.signIn(email: email, password: password)
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
                    } label: {
                        HStack {
                            Text("Log In")
                                .fontWeight(.semibold)
                                .font(.system(size: 20))
                        }
                    }
                    .makeButtonStyle(tintColor: .white, backgroundColor: Color.red, width: UIScreen.main.bounds.width - 40, height: 64)
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                }
                .padding(.top, 24)
            }
            .padding()
            .background(.pageBack)
        }
    }
}




#Preview {
    LoginView()
}
