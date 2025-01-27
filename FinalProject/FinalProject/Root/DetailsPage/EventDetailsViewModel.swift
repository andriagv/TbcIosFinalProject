//
//  EventDetailsViewModel.swift
//  FinalProject
//
//  Created by Apple on 26.01.25.
//


import Foundation
import UIKit

@MainActor
class EventDetailsViewModel: ObservableObject {
    @Published var isFavorite: Bool
    @Published var showQRCode = false
    @Published var currentPhotoIndex = 0
    @Published var showNoSeatsAlert = false
    @Published var showBookingConfirmation = false
    @Published var currentSeats: Int
    @Published var images: [String: UIImage] = [:]
    
    private var loadingTasks: [String: Task<Void, Never>] = [:]
    let event: Event
    
    init(event: Event) {
        self.event = event
        self.isFavorite = event.isFavorite
        self.currentSeats = event.seats.available
        checkLikeStatus()
        loadAllImages()
    }
    
    deinit {
        loadingTasks.values.forEach { $0.cancel() }
    }

    private func loadAllImages() {
        for photoName in event.photos {
            loadImage(photoName: photoName)
        }
    }
    
    private func loadImage(photoName: String) {
        loadingTasks[photoName]?.cancel()
        
        loadingTasks[photoName] = Task { @MainActor in
            do {
                if let image = try await ImageCacheManager.shared.fetchPhoto(
                    photoName: photoName,
                    cacheType: .detailsPage
                ) {
                    if !Task.isCancelled {
                        images[photoName] = image
                    }
                }
            } catch {
                print("Error loading image \(photoName): \(error)")
                if !Task.isCancelled {
                    images[photoName] = UIImage(named: "placeholder")
                }
            }
        }
    }
    
    func getImage(for photoName: String) -> UIImage? {
        return images[photoName] ?? UIImage(named: "placeholder")
    }
    
    func toggleFavorite() {
        Task {
            guard let userId = UserDefaultsManager.shared.getUserId() else { return }
            do {
                if isFavorite {
                    try await LikedEventsManager.shared.removeLikedEvent(for: userId, event: event)
                } else {
                    try await LikedEventsManager.shared.addLikedEvent(for: userId, event: event)
                }
                isFavorite.toggle()
                LikeStatusMonitor.shared.statusChanged()
            } catch {
                print("Error toggling favorite: \(error)")
            }
        }
    }
    
    func checkLikeStatus() {
        Task { [weak self] in
            guard let self = self else { return }
            if let userId = UserDefaultsManager.shared.getUserId() {
                let isLiked = try? await LikedEventsManager.shared.isEventLiked(
                    eventId: event.id,
                    userId: userId
                )
                self.isFavorite = isLiked ?? false
            }
        }
    }
    
    func formatDateRange() -> String {
        guard let endDate = event.date.endDate else {
            return event.date.startDate
        }
        return "\(event.date.startDate) \(endDate)"
    }
    
    func formatLocation() -> String {
        guard let city = event.location.city else {
            return event.location.address ?? "Unknown location"
        }
        return "\(city), \(event.location.address ?? "")"
    }
    
    func formatDuration() -> String {
        if let days = event.date.durationInDays {
            return "\(days) " + (days == 1 ? "day" : "days")
        }
        return "0 days"
    }
    
    func updateSeatsLocally() {
        currentSeats -= 1
    }
}
