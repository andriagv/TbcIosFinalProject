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
        VStack(alignment: .leading, spacing: 8) {
            VStack {
                if let firstPhoto = event.photos.first {
                    Image(firstPhoto)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 100)
                        .cornerRadius(10)
                        .clipped()
                        .shadow(color: .collectionShadow.opacity(0.6), radius: 10, x: 0, y: 5)
                } else {
                    Image(systemName: "photo")
                }
            }
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "mappin.circle")
                    Text(event.name)
                        .makeTextStyle(color: .primary, size: 14, font: "SourGummy-Bold")
                }
                HStack {
                    Image(systemName: "clock")
                    Text(event.date.startDate)
                        .makeTextStyle(color: .primary, size: 14, font: "SourGummy-Bold")
                }
                HStack {
                    Image(systemName: "dollarsign.circle")
                    Text("price: \(event.price.startPrice, specifier: "%.2f")")
                        .makeTextStyle(color: .primary, size: 14, font: "SourGummy-Bold")
                }
            }
            .padding(.top, 8)
        }
        .frame(width: 160, height: 220)
        .padding(.horizontal, 8)
        .background(.tableCellBackground)
        .cornerRadius(10)
        .shadow(color: .collectionShadow.opacity(0.4), radius: 5, x: 0, y: 3)
    }
}


#Preview() {
    CartSmallView(event: Event(
        id: UUID().uuidString,
        name: "ulamazesi usba",
        type: .hiking,
        price: Price(startPrice: 20.0, discountedPrice: nil),
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
