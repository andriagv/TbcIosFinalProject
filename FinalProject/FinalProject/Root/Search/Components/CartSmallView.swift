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
    @EnvironmentObject var viewModel: SearchPageViewModel
    @StateObject private var likeStatusMonitor = LikeStatusMonitor()
    
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
                    Image(systemName: "photo.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
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
                
                .padding(8)
            }
            VStack(spacing: 8) {
                VStack(spacing: 6) {
                    CompactDetailRow(
                        icon: "mappin.circle",
                        iconColor: .blue,
                        text: event.name
                    )
                    CompactDetailRow(
                        icon: "clock",
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
        .onAppear {
            checkLikeStatus()
        }
        .onReceive(likeStatusMonitor.$lastUpdated) { _ in
            checkLikeStatus()
        }
        .frame(width: 160)
        .background(Color(.filterSheetBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .collectionShadow.opacity(0.1), radius: 8, x: 0, y: 3)
    }
    
    private func checkLikeStatus() {
        Task {
            if let userId = UserDefaultsManager.shared.getUserId() {
                let isLiked = try? await LikedEventsManager.shared.isEventLiked(
                    eventId: event.id,
                    userId: userId
                )
                await MainActor.run {
                    self.isLiked = isLiked ?? false
                }
            }
        }
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
