//
//  LikedEventCardViewModel.swift
//  FinalProject
//
//  Created by Apple on 27.01.25.
//


import Foundation
import SwiftUI

@MainActor
final class LikedEventCardViewModel: ObservableObject {
    @Published private(set) var event: Event
    @Published private(set) var image: UIImage?
    
    private let onUnlike: () -> Void
    private let onCardTap: () -> Void
    
    init(event: Event, onUnlike: @escaping () -> Void, onCardTap: @escaping () -> Void) {
        self.event = event
        self.onUnlike = onUnlike
        self.onCardTap = onCardTap
        
        Task {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        if let photoName = event.photos.first {
            do {
                self.image = try await ImageCacheManager.shared.fetchPhoto(
                    photoName: photoName,
                    cacheType: .profilePage
                )
            } catch {
                print("Error loading image for event \(event.id): \(error)")
            }
        }
    }
    
    var eventName: String {
        event.name
    }
    
    var eventAddress: String {
        event.location.address ?? "No address"
    }
    
    var formattedDate: String {
        DateFormatterManager.shared.formatDate(event.date.startDate)
    }
    
    var priceDisplay: (originalPrice: Double, discountedPrice: Double?) {
        (event.price.startPrice, event.price.discountedPrice)
    }
    
    func handleUnlike() {
        onUnlike()
    }
    
    func handleCardTap() {
        onCardTap()
    }
}
