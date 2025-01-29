//
//  EventDetailsViewModel.swift
//  FinalProject
//
//  Created by Apple on 26.01.25.
//


import Foundation
import UIKit

protocol LikeStatusObservable {
    var lastUpdated: Date { get }
    var likeStatusPublisher: Published<Date>.Publisher { get }
    func statusChanged()
}

@MainActor
final class EventDetailsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var images: [String: UIImage] = [:]
    @Published var isFavorite: Bool
    @Published var showQRCode = false
    @Published var currentPhotoIndex = 0
    @Published var showNoSeatsAlert = false
    @Published var showBookingConfirmation = false
    @Published var currentSeats: Int
    
    @Published private var lastLikeUpdate: Date = Date()
    
    var likeStatusPublisher: Published<Date>.Publisher {
        $lastLikeUpdate
    }
    
    // MARK: - Private Properties
    private var loadingTasks: [String: Task<Void, Never>] = [:]
    private let imageLoader: ImageLoadable
    private let formatter: EventFormattable
    private let likedEventsManager: LikedEventsManager
    private let userDefaults: UserDefaultsManager
    
    // MARK: - Public Properties
    let event: Event
    
    // MARK: - Initialization
    init(
        event: Event,
        imageLoader: ImageLoadable = EventImageLoader(),
        formatter: EventFormattable = EventFormatter(),
        likedEventsManager: LikedEventsManager = .shared,
        userDefaults: UserDefaultsManager = .shared
    ) {
        self.event = event
        self.isFavorite = event.isFavorite
        self.currentSeats = event.seats.available
        self.imageLoader = imageLoader
        self.formatter = formatter
        self.likedEventsManager = likedEventsManager
        self.userDefaults = userDefaults
        
        checkLikeStatus()
        loadAllImages()
    }
    
    deinit {
        loadingTasks.values.forEach { $0.cancel() }
    }
    
    // MARK: - Image Loading
    private func loadAllImages() {
        for photoName in event.photos {
            loadImage(photoName: photoName)
        }
    }
    
    private func loadImage(photoName: String) {
        loadingTasks[photoName]?.cancel()
        
        loadingTasks[photoName] = Task { @MainActor in
            do {
                if let image = try await imageLoader.loadImage(photoName: photoName) {
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
    
    // MARK: - Like Management
    func toggleFavorite() {
        Task {
            guard let userId = userDefaults.getUserId() else { return }
            do {
                if isFavorite {
                    try await likedEventsManager.removeLikedEvent(for: userId, event: event)
                } else {
                    try await likedEventsManager.addLikedEvent(for: userId, event: event)
                }
                isFavorite.toggle()
                LikeStatusMonitor.shared.statusChanged()
            } catch {
                print("Error toggling favorite: \(error)")
            }
        }
    }
    
    private func checkLikeStatus() {
        Task {
            guard let userId = userDefaults.getUserId() else { return }
            do {
                isFavorite = try await likedEventsManager.isEventLiked(
                    eventId: event.id,
                    userId: userId
                )
            } catch {
                isFavorite = false
                print("Error checking like status: \(error)")
            }
        }
    }
    
    // MARK: - Formatting
    func formatDateRange() -> String {
        formatter.formatDateRange(startDate: event.date.startDate, endDate: event.date.endDate)
    }
    
    func formatLocation() -> String {
        formatter.formatLocation(city: event.location.city, address: event.location.address)
    }
    
    func formatDuration() -> String {
        formatter.formatDuration(days: event.date.durationInDays)
    }
    
    // MARK: - Seats Management
    func updateSeatsLocally() {
        currentSeats -= 1
    }
    
    func refreshLikeStatus() {
        checkLikeStatus()
    }
    
    func updateLikeStatus() {
        lastLikeUpdate = Date()
    }
}
