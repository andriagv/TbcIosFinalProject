//
//  CartBigView.swift
//  FinalProject
//
//  Created by Apple on 18.01.25.
//


import SwiftUI

struct CartBigView: View {
    @StateObject private var viewModel: CartViewModel
    @Environment(\.colorScheme) var colorScheme
    
    init(event: Event) {
        _viewModel = StateObject(wrappedValue: CartViewModel(event: event))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                if let uiImage = viewModel.image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: UIScreen.main.bounds.width * 0.6)
                        .frame(width: UIScreen.main.bounds.width * 0.83)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .opacity(colorScheme == .dark ? 0.9 : 1)
                } else {
                    Image(systemName: "photo.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                        .frame(height: UIScreen.main.bounds.width * 0.6)
                        .frame(width: UIScreen.main.bounds.width * 0.83)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                }
                
                Button(action: {
                    Task { await viewModel.toggleLike() }
                }) {
                    SmallButtonView(
                        imageSystemName: viewModel.isLiked ? "heart.fill" : "heart",
                        fontSize: 20
                    )
                    .foregroundStyle(viewModel.isLiked ? Color.red : Color.white)
                }
                .padding(16)
            }
            
            VStack(spacing: 10) {
                HStack {
                    VStack(spacing: 12) {
                        DetailRow(
                            icon: "mappin.circle",
                            iconColor: .blue,
                            text: viewModel.name
                        )
                        DetailRow(
                            icon: "clock",
                            iconColor: .blue,
                            text: viewModel.formattedStartDate
                        )
                    }
                    VStack(spacing: 12) {
                        DetailRow(
                            icon: "tent.2.circle",
                            iconColor: .blue,
                            text: "\(viewModel.type)"
                        )
                        DetailRow(
                            icon: "figure.walk.circle",
                            iconColor: .blue,
                            text: "\(viewModel.availableSeats) / \(viewModel.totalSeats)"
                        )
                    }
                }
                PriceDisplayView(
                    startPrice: viewModel.startPrice,
                    discountedPrice: viewModel.discountedPrice
                )
            }
            .padding(.top)
        }
        .task {
            await viewModel.loadImage()
        }
        .padding()
        .background(Color(.filterSheetBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 16)
        .shadow(
            color: .collectionShadow.opacity(0.3),
            radius: 5,
            x: 2,
            y: 2
        )
    }
}

