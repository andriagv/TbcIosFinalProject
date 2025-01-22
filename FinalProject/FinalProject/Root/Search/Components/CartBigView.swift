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
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .opacity(colorScheme == .dark ? 0.9 : 1)
                Button(action: { isLiked.toggle() }) {
                    Circle()
                        .fill(Color(.systemBackground))
                        .frame(width: 30, height: 30)
                        .overlay(
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .foregroundStyle(isLiked ? Color.red : Color.gray)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                }
                .padding(16)
            }
            VStack(spacing: 10) {
                HStack() {
                    VStack(spacing: 12) {
                        DetailRow(
                            icon: "mappin.circle.fill",
                            iconColor: .red,
                            text: event.name
                        )
                        DetailRow(
                            icon: "clock.fill",
                            iconColor: .blue,
                            text: DateFormatterManager.shared.formatDate(event.date.startDate)
                        )
                    }
                    VStack(spacing: 12) {
                        DetailRow(
                            icon: "tent.2.circle.fill",
                            iconColor: .red,
                            text: "\(event.type)"
                        )
                        DetailRow(
                            icon: "figure.walk.circle.fill",
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
