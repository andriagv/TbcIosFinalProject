//
//  CartSmallView.swift
//  fin_hel
//
//  Created by Apple on 10.01.25.
//


import SwiftUI

struct CartSmallView: View {
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
                if let firstPhoto = event.photos.first {
                    Image(firstPhoto)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .opacity(colorScheme == .dark ? 0.9 : 1)
                } else {
                    Image(systemName: "photo")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                Button(action: { isLiked.toggle() }) {
                    Circle()
                        .fill(Color(.systemBackground))
                        .frame(width: 30, height: 30)
                        .overlay(
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .font(.system(size: 12))
                                .foregroundStyle(isLiked ? Color.red : Color.gray)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                .padding(8)
            }
            VStack(spacing: 8) {
                VStack(spacing: 6) {
                    CompactDetailRow(
                        icon: "mappin.circle.fill",
                        iconColor: .red,
                        text: event.name
                    )
                    CompactDetailRow(
                        icon: "clock.fill",
                        iconColor: .blue,
                        text: event.date.startDate
                    )
                    CompactPriceRow(
                        startPrice: event.price.startPrice,
                        discountedPrice: event.price.discountedPrice
                    )
                }
            }
            .padding(8)
            .background(Color(.filterSheetBackground))
        }
        .frame(width: 160)
        .background(Color(.filterSheetBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .collectionShadow.opacity(0.1), radius: 8, x: 0, y: 3)
    }
}

#Preview() {
    CartSmallView(event: Event(
        id: UUID().uuidString,
        name: "ulamazesi usba",
        type: .hiking,
        price: Price(startPrice: 20.0, discountedPrice: 14),
        date: EventDate(startDate: "2025-03-05", endDate: nil, durationInDays: 1),
        location: Location(latitude: 41.7151, longitude: 44.8271, address: "Mtatsminda Park", city: "svaneti"),
        seats: Seats(total: 30, available: 15),
        photos: ["svaneti"],
        organizerContact: "hikegeorgia@gmail.com",
        requirements: ["Comfortable Shoes"],
        tags: ["City", "Adventure"],
        isFavorite: true,
        description: "Experience the beauty of Tbilisi with a guided hiking tour."
    ) )
}
