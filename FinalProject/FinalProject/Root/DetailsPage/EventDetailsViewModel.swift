//
//  EventDetailsViewModel.swift
//  FinalProject
//
//  Created by Apple on 26.01.25.
//


import Foundation

@MainActor
class EventDetailsViewModel: ObservableObject {
   @Published var isFavorite: Bool
   @Published var showQRCode = false
   @Published var currentPhotoIndex = 0
   
   let event: Event
   
   init(event: Event) {
       self.event = event
       self.isFavorite = event.isFavorite
       checkLikeStatus()
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
       Task {
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
}