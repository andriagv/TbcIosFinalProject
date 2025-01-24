//
//  CartBigView.swift
//  FinalProject
//
//  Created by Apple on 18.01.25.
//


import SwiftUI

struct CartBigView: View {
    @State private var isLiked: Bool
    let event: Event
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: SearchPageViewModel
    
    init(event: Event) {
        self.event = event
        self._isLiked = State(initialValue: event.isFavorite)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                Image(event.photos.first ?? "photo")
                    .resizable()
                    .scaledToFill()
                    .frame(height: UIScreen.main.bounds.width * 0.6)
                    .frame(width: UIScreen.main.bounds.width * 0.83)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .opacity(colorScheme == .dark ? 0.9 : 1)
                Button(action: { isLiked.toggle() }) {
                    Button(action: {
                        isLiked.toggle()
                        Task {
                            do {
                                try await viewModel.toggleLike(for: event)
                            } catch {
                                print("Error toggling like: \(error)")
                            }
                        }
                    }) {
                        SmallButtonView(imageSystemName: isLiked ? "heart.fill" : "heart", fontSize: 20)
                            .foregroundStyle(isLiked ? Color.red : Color.white)
                    }
                }
                .padding(16)
            }
            VStack(spacing: 10) {
                HStack() {
                    VStack(spacing: 12) {
                        DetailRow(
                            icon: "mappin.circle",
                            iconColor: .blue,
                            text: event.name
                        )
                        DetailRow(
                            icon: "clock",
                            iconColor: .blue,
                            text: DateFormatterManager.shared.formatDate(event.date.startDate)
                        )
                    }
                    VStack(spacing: 12) {
                        DetailRow(
                            icon: "tent.2.circle",
                            iconColor: .blue,
                            text: "\(event.type)"
                        )
                        DetailRow(
                            icon: "figure.walk.circle",
                            iconColor: .blue,
                            text: "\(event.seats.available) / \(event.seats.total)")
                    }
                }
                PriceDisplayView(
                    startPrice: event.price.startPrice,
                    discountedPrice: event.price.discountedPrice
                )
            }
            .padding(.top)
        }
        .padding()
        .background(Color(.filterSheetBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 16)
        .shadow(
            color: .collectionShadow.opacity(0.5),
            radius: 10,
            x: 2,
            y: 2
        )
    }
}

#Preview() {
    SearchView()
}
