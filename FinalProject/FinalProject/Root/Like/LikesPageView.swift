//
//  LikesPageView.swift
//  FinalProject
//
//  Created by Apple on 19.01.25.
//


import SwiftUI

struct LikesPageView: View {
    @StateObject private var viewModel = LikesViewModel()
    @ObservedObject var languageManager = LanguageManager.shared
    
    var onEventSelected: (Event) -> Void
    
    
    var body: some View {
        ScrollView {
            if viewModel.networkError {
                VStack {
                    Spacer()
                    networkErrorView
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.likedEvents) { event in
                        LikedEventCard(
                            event: event,
                            onUnlike: {
                                Task {
                                    try? await viewModel.unlikeEvent(event)
                                }
                            },
                            onCardTap: {
                                onEventSelected(event)
                            }
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 16)
            }
        }
        .background(.pageBack)
        .overlay(Group {
            if viewModel.likedEvents.isEmpty && !viewModel.isLoading && !viewModel.networkError {
                EmptyStateView()
            }
        })
        .id(languageManager.selectedLanguage)
    }
    
    private var networkErrorView: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("Unable to connect to the internet".localized())
                .font(.headline)
            
            Text("Please check your internet connection and try again.".localized())
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button {
                //viewModel.fetchLikedEvents()
            } label: {
                Text("Retry".localized())
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.top)
        }
    }
}

#Preview {
    LikesPageView(onEventSelected: { _ in })
}
