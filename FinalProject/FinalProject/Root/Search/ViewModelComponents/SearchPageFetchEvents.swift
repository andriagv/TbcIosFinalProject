//
//  SearchPageFetchEvents.swift
//  FinalProject
//
//  Created by Apple on 31.01.25.
//


import Foundation
import FirebaseDatabase

final class SearchPageFetchEvents {
    static func fetchEvents(
        userId: String,
        selectedCategory: EventType?,
        databaseRef: DatabaseReference,
        completion: @escaping ([Event]) -> Void
    ) {
        Task {
            do {
                let user = try await UserManager().getUser(by: userId)
                let likedEventIds = user.likedEventIds
                
                let eventsRef = databaseRef.child("events")
                
                eventsRef.observeSingleEvent(of: .value) { snapshot in
                    if !snapshot.hasChildren() {
                        completion([])
                        return
                    }
                    
                    var fetchedEvents: [Event] = []
                    
                    for child in snapshot.children {
                        if let snap = child as? DataSnapshot,
                           let dict = snap.value as? [String: Any],
                           let eventObj = parseEvent(dict: dict) {
                            
                            // კატეგორიის ფილტრი
                            if let category = selectedCategory, eventObj.type != category {
                                continue
                            }
                            
                            var updatedEvent = eventObj
                            updatedEvent.isFavorite = likedEventIds.contains(updatedEvent.id)
                            fetchedEvents.append(updatedEvent)
                        }
                    }
                    
                    completion(fetchedEvents)
                }
            } catch {
                completion([])
            }
        }
    }
    
    private static func parseEvent(dict: [String: Any]) -> Event? {
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: [])
            let decoded = try JSONDecoder().decode(Event.self, from: data)
            return decoded
        } catch {
            return nil
        }
    }
}
