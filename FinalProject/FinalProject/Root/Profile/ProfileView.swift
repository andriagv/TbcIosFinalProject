//
//  ProfileView.swift
//  FinalProject
//
//  Created by Apple on 12.01.25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @ObservedObject var languageManager = LanguageManager.shared
    @State private var isLanguageSelectionExpanded = false
    
    var body: some View {
        NavigationView {
            VStack {
                profileHeader
                Divider().padding(.horizontal)
                List {
                    languageSection
                    navigationLinks
                    darkModeToggle
                    logoutButton
                }
            }
            .navigationTitle("My Profile".localized())
        }
    }
    
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
                Button(action: {
                    // Edit Action
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
        }
        .padding(.top)
    }
    
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
    
    private var navigationLinks: some View {
        NavigationLink(destination: Text("Personal Notifications".localized())) {
            HStack {
                Image(systemName: "bell")
                    .foregroundColor(.blue)
                Text("Personal Notifications".localized())
            }
        }
    }
    
    private var darkModeToggle: some View {
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
    
    private var logoutButton: some View {
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

#Preview {
    ProfileView()
}
