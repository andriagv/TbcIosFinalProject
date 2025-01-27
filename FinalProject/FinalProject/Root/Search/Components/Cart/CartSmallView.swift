//
//  CartSmallView.swift
//  fin_hel
//
//  Created by Apple on 10.01.25.
//


import SwiftUI

struct CartSmallView: View {
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
                        .frame(height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .opacity(colorScheme == .dark ? 0.9 : 1)
                } else {
                    Image(systemName: "photo.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
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
                .padding(8)
            }
            
            VStack(spacing: 8) {
                VStack(spacing: 6) {
                    CompactDetailRow(
                        icon: "mappin.circle",
                        iconColor: .blue,
                        text: viewModel.name
                    )
                    CompactDetailRow(
                        icon: "clock",
                        iconColor: .blue,
                        text: viewModel.startDate
                    )
                    CompactPriceRow(
                        startPrice: viewModel.startPrice,
                        discountedPrice: viewModel.discountedPrice
                    )
                }
            }
            .padding(8)
            .background(Color(.filterSheetBackground))
        }
        .task {
            await viewModel.loadImage()
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
        photos: [],
        organizerContact: "hikegeorgia@gmail.com",
        requirements: ["Comfortable Shoes"],
        tags: ["City", "Adventure"],
        isFavorite: true,
        description: "Experience the beauty of Tbilisi with a guided hiking tour."
    ) )
}
