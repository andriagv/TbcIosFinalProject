//
//  EditProfileView.swift
//  FinalProject
//
//  Created by Apple on 23.01.25.
// 

import SwiftUI

struct EditProfileView: View {
    @StateObject private var viewModel = EditProfileViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showPasswordSection = false
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Profile Photo".localized())) {
                HStack {
                    if let selectedImage = viewModel.selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else if let photoUrl = profileViewModel.user?.photoUrl, !photoUrl.isEmpty {
                        AsyncImage(url: URL(string: photoUrl)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } placeholder: {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 100, height: 100)
                        }
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 100, height: 100)
                    }
                    
                    Button(action: {
                        viewModel.showImagePicker = true
                    }) {
                        Text("Change Photo".localized())
                    }
                }
            }
            
            profileSection
            passwordSection
            
            Section {
                saveButton
            }
        }
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(selectedImage: $viewModel.selectedImage)
        }
        .alert("Error".localized(), isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
        .disabled(viewModel.isLoading)
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack {
                        SmallButtonView(imageSystemName: "chevron.left", fontSize: 20)
                    }
                }
            }
        }
    }
    
    private var profileSection: some View {
        Section(header: Text("Profile Information".localized())) {
            TextField("Full Name".localized(), text: $viewModel.fullName)
                .textContentType(.name)
            
            TextField("Username".localized(), text: $viewModel.username)
                .textContentType(.username)
        }
    }
    
    private var passwordSection: some View {
        Section(header: Text("Change Password".localized())) {
            if !showPasswordSection {
                Button("Change Password".localized()) {
                    withAnimation {
                        showPasswordSection = true
                    }
                }
            } else {
                SecureField("Current Password".localized(), text: $viewModel.currentPassword)
                    .textContentType(.password)
                
                SecureField("New Password".localized(), text: $viewModel.newPassword)
                    .textContentType(.newPassword)
                
                SecureField("Confirm New Password".localized(), text: $viewModel.confirmPassword)
                    .textContentType(.newPassword)
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            Task {
                if showPasswordSection && !viewModel.currentPassword.isEmpty {
                    if await viewModel.updatePassword() {
                        viewModel.currentPassword = ""
                        viewModel.newPassword = ""
                        viewModel.confirmPassword = ""
                        showPasswordSection = false
                    }
                }
                
                if await viewModel.updateProfile() {
                    if let image = viewModel.selectedImage {
                        await profileViewModel.updateUserProfile(
                            fullname: viewModel.fullName,
                            username: viewModel.username,
                            image: image
                        )
                    } else {
                        await profileViewModel.updateUserProfile(
                            fullname: viewModel.fullName,
                            username: viewModel.username,
                            image: nil
                        )
                    }
                    dismiss()
                }
                
                if let error = viewModel.error {
                    alertMessage = error.localizedDescription
                    showingAlert = true
                }
            }
        }) {
            Text("Save Changes".localized())
        }
    }
}

#Preview() {
    ProfileView()
}
