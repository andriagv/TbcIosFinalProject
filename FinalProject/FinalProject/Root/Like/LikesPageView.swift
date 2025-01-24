//
//  LikesPageView.swift
//  FinalProject
//
//  Created by Apple on 24.01.25.
//


import SwiftUI


struct LikesPageView: View {
    @StateObject private var viewModel = LikesViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.likedEvents) { event in
                            LikedEventCard(event: event, onUnlike: {
                                Task {
                                    try? await viewModel.unlikeEvent(event)
                                }
                            })
                        }
                    }
                    .padding()
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("ფავორიტები")
            .overlay(Group {
                if viewModel.likedEvents.isEmpty && !viewModel.isLoading {
                    EmptyStateView()
                }
            })
        }
    }
}

#Preview {
    LikesPageView()
}
