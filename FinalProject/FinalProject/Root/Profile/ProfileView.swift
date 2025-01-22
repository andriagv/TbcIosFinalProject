//
//  ProfileView.swift
//  FinalProject
//
//  Created by Apple on 12.01.25.
//

import SwiftUI
import StoreKit //  შეფასების ან გამოწერების მართვის ფუნქცია თუ დავამატე

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @ObservedObject var languageManager = LanguageManager.shared
    @State private var isLanguageSelectionExpanded = false
    
    @State private var showContactUsSheet = false
    @State private var showPrivacySheet = false
    @State private var showTermsSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                profileHeader
                Divider()
                    .padding(.horizontal)
                List {
                    languageSection
                    notificationsSection
                    darkModeToggleSection
                    accountManagementSection
                    helpAndSupportSection
                    appInfoSection
                    logoutButton
                }
            }
            .navigationTitle("My Profile".localized())
        }
    }
    
    // MARK: - პროფილის ჰედერი
    private var profileHeader: some View {
        VStack(alignment: .leading) {
            HStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                    )
                VStack(alignment: .leading) {
                    Text("Name")
                        .font(.headline)
                    Text("Email@gmail.com")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                NavigationLink {
                    EditProfileView()
                } label: {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .padding(.horizontal)
        }
        .padding(.top)
    }
    
    // MARK: - ენების სექცია
    private var languageSection: some View {
        Section(header: Text("Language".localized())) {
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "globe")
                        .foregroundColor(.blue)
                    Text("Select Language".localized())
                    Spacer()
                    Image(systemName: isLanguageSelectionExpanded ? "chevron.up" : "chevron.down")
                        .resizable()
                        .frame(width: 14, height: 8)
                        .foregroundColor(.blue)
                        .animation(.easeInOut, value: isLanguageSelectionExpanded)
                }
                .onTapGesture {
                    withAnimation {
                        isLanguageSelectionExpanded.toggle()
                    }
                }
                
                if isLanguageSelectionExpanded {
                    Picker("Select Language".localized(), selection: $languageManager.selectedLanguage) {
                        ForEach(languageManager.supportedLanguages, id: \.self) { language in
                            Text(languageManager.languageDisplayName(for: language))
                                .tag(language)
                        }
                    }
                    .pickerStyle(.wheel)
                    .padding(.top, 10)
                }
            }
        }
    }
    
    // MARK: - პირადი შეტყობინებების სექცია
    private var notificationsSection: some View {
        Section {
            NavigationLink(destination: Text("Personal Notifications".localized())) {
                HStack {
                    Image(systemName: "bell")
                        .foregroundColor(.blue)
                    Text("Personal Notifications".localized())
                }
            }
        }
    }
    
    // MARK: - დარკ მოუდი
    private var darkModeToggleSection: some View {
        Section {
            HStack {
                Image(systemName: "moon")
                    .foregroundColor(.blue)
                Text("Dark Mode".localized())
                Spacer()
                Toggle("", isOn: Binding(
                    get: { viewModel.selectedTheme == .dark },
                    set: { isDark in
                        let theme: AppTheme = isDark ? .dark : .light
                        if let window = UIApplication.shared.connectedScenes
                            .compactMap({ $0 as? UIWindowScene })
                            .flatMap({ $0.windows })
                            .first {
                            viewModel.setTheme(theme, for: window)
                        }
                    }
                ))
                .labelsHidden()
            }
        }
    }
    
    // MARK: - ანგარიში: Edit / Delete
    private var accountManagementSection: some View {
        Section(header: Text("Account Management".localized())) {
            NavigationLink(destination: EditProfileView()) {
                HStack {
                    Image(systemName: "person.crop.circle")
                        .foregroundColor(.blue)
                    Text("Edit Profile".localized())
                }
            }
            Button(role: .destructive, action: {
                //  Delete Account ლოგიკა
                //  Alert-იც გამოგადგეთ დასადასტურებლად
            }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete Account".localized())
                }
            }
        }
    }
    
    // MARK: - დახმარება და ფიდბექი
    private var helpAndSupportSection: some View {
        Section(header: Text("Help & Support".localized())) {
            Button(action: {
                showContactUsSheet = true
            }) {
                HStack {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(.blue)
                    Text("Contact Us".localized())
                }
            }
            .sheet(isPresented: $showContactUsSheet) {
                ContactUsViewControllerRepresentable()
                    .presentationDetents([.fraction(0.7)])
                    .presentationDragIndicator(.visible)
            }
            Button(action: {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            }) {
                HStack {
                    Image(systemName: "star.bubble")
                        .foregroundColor(.blue)
                    Text("Rate Us".localized())
                }
            }
        }
    }
    
    // MARK: - აპის შესახებ, Terms/Privacy, ვერსია
    private var appInfoSection: some View {
        Section(header: Text("App Info".localized())) {
            Button(action: {
                showTermsSheet = true
            }) {
                HStack {
                    Image(systemName: "doc.text")
                        .foregroundColor(.blue)
                    Text("Terms & Conditions".localized())
                }
            }
            .sheet(isPresented: $showTermsSheet) {
                TermsAndConditionsViewControllerRepresentable()
            }
            Button(action: {
                showPrivacySheet = true
            }) {
                HStack {
                    Image(systemName: "shield.lefthalf.filled")
                        .foregroundColor(.blue)
                    Text("Privacy Policy".localized())
                }
            }
            .sheet(isPresented: $showPrivacySheet) {
                PrivacyPolicyViewControllerRepresentable()
            }
            HStack {
                Image(systemName: "info.circle")
                    .foregroundColor(.gray)
                Text("Version".localized())
                Spacer()
                Text("1.0.0 (Build 10)")
                    .foregroundColor(.gray)
            }
        }
    }
    
    // MARK: - გამოსვლა
    private var logoutButton: some View {
        Section {
            Button(action: {
                // Logout Logic
            }) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(.red)
                    Text("Logout".localized())
                        .foregroundColor(.red)
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
