//
//  CartViewModel.swift
//  FinalProject
//
//  Created by Apple on 28.01.25.
//


import SwiftUI

@MainActor
final class CartViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var isLiked: Bool
    
    private let event: Event
    private let cacheType: ImageCacheManager.CacheType
    
    init(event: Event, cacheType: ImageCacheManager.CacheType = .searchPage) {
        self.event = event
        self.cacheType = cacheType
        self.isLiked = event.isFavorite
    }
    
    func loadImage() async {
        if let photoName = event.photos.first {
            do {
                if let loadedImage = try await ImageCacheManager.shared.fetchPhoto(
                    photoName: photoName,
                    cacheType: cacheType
                ) {
                    self.image = loadedImage
                }
            } catch {
                print("Error loading image for \(event.name): \(error)")
            }
        }
    }
    
    func toggleLike() async {
        do {
            guard let userId = UserDefaultsManager.shared.getUserId() else { return }
            
            isLiked.toggle()
            
            if isLiked {
                try await LikedEventsManager.shared.addLikedEvent(for: userId, event: event)
            } else {
                try await LikedEventsManager.shared.removeLikedEvent(for: userId, event: event)
            }
        } catch {
            isLiked.toggle()
            print("Error toggling like: \(error)")
        }
    }
    
    var name: String { event.name }
    var startDate: String { event.date.startDate }
    var formattedStartDate: String { 
        DateFormatterManager.shared.formatDate(event.date.startDate)
    }
    var type: EventType { event.type }
    var availableSeats: Int { event.seats.available }
    var totalSeats: Int { event.seats.total }
    var startPrice: Double { event.price.startPrice }
    var discountedPrice: Double? { event.price.discountedPrice }
}
