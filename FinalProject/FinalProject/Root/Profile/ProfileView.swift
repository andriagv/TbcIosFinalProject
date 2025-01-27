//
//  ProfileView.swift
//  FinalProject
//
//  Created by Apple on 12.01.25.
//

import SwiftUI
import StoreKit

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @ObservedObject var languageManager = LanguageManager.shared
    @State private var isLanguageSelectionExpanded = false
    
    @State private var showContactUsSheet = false
    @State private var showPrivacySheet = false
    @State private var showTermsSheet = false
    @State private var showingDeleteAlert = false
    @State private var isShowingTickets = false

    @State private var showToast = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.pageBack.edgesIgnoringSafeArea(.all)
                
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
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.pageBack)
                    .listRowBackground(Color.pageBack)
                    .listSectionSeparator(.hidden)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .navigationTitle("My Profile".localized())
            .overlay(alignment: .top) {
                if showToast {
                    ToastView(message: "Deleted account".localized())
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
            .sheet(isPresented: $isShowingTickets) {
               TicketsViewControllerRepresentable()
            }
        }
    }
    
    private var profileHeader: some View {
        VStack(alignment: .leading) {
            HStack {
                if let user = viewModel.user {
                    if !user.photoUrl.isEmpty {
                        AsyncImage(url: URL(string: user.photoUrl)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } placeholder: {
                            defaultProfileImage
                        }
                    } else {
                        defaultProfileImage
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.fullName)
                            .font(.headline)
                            .foregroundColor(.customPageTitle)
                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    NavigationLink {
                        EditProfileView(profileViewModel: viewModel)
                    } label: {
                        Image(systemName: "pencil")
                            .foregroundColor(.red)
                            .padding()
                    }
                } else {
                    defaultProfileImage
                    VStack(alignment: .leading) {
                        Text("Loading...".localized())
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
            }
            .padding(.horizontal)
        }
        .padding(.top)
    }

    private var defaultProfileImage: some View {
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
    }

    private var languageSection: some View {
        Section(header: Text("Language".localized()).foregroundColor(.gray)) {
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
        .listRowBackground(Color.pageBack)
    }

    private var notificationsSection: some View {
        Section {
            Button {
                isShowingTickets = true
            } label: {
                HStack {
                    Image(systemName: "ticket")
                        .foregroundColor(.blue)
                    Text("My Tickets".localized())
                }
            }
        }
        .listRowBackground(Color.pageBack)
    }

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
        .listRowBackground(Color.pageBack)
    }

    private var accountManagementSection: some View {
        Section(header: Text("Account Management".localized()).foregroundColor(.gray)) {
            NavigationLink(destination: EditProfileView(profileViewModel: viewModel)) {
                HStack {
                    Image(systemName: "person.crop.circle")
                        .foregroundColor(.blue)
                    Text("Edit Profile".localized())
                }
            }
            Button(role: .destructive, action: {
                showingDeleteAlert = true
            }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete Account".localized())
                }
            }
            .alert("Delete Account?".localized(), isPresented: $showingDeleteAlert) {
                Button("Delete".localized(), role: .destructive) {
                    withAnimation {
                        showToast = true
                    }
                    Task {
                        await viewModel.deleteAccount()
                    }
                }
                Button("Cancel".localized(), role: .cancel) {}
            }
            
        }
        .listRowBackground(Color.pageBack)
    }

    private var helpAndSupportSection: some View {
        Section(header: Text("Help & Support".localized()).foregroundColor(.gray)) {
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
        .listRowBackground(Color.pageBack)
    }

    private var appInfoSection: some View {
        Section(header: Text("App Info".localized()).foregroundColor(.gray)) {
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
        .listRowBackground(Color.pageBack)
    }

    private var logoutButton: some View {
        Section {
            Button(action: {
                viewModel.signOut()
            }) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(.red)
                    Text("Logout".localized())
                        .foregroundColor(.red)
                }
            }
        }
        .listRowBackground(Color.pageBack)
    }
}

#Preview {
    ProfileView()
}
