//
//  EventRepository.swift
//  FinalProject
//
//  Created by Apple on 29.01.25.
//



import Foundation
import FirebaseDatabase
import FirebaseFirestore

// MARK: - Protocol
protocol EventFetchable {
    func fetchEvents(pageSize: UInt, lastKey: String?) async throws -> [Event]
    func fetchEventsByCategory(_ category: EventType) async throws -> [Event]
}

// MARK: - Error Handling
enum RepositoryError: LocalizedError {
    case userNotAuthenticated
    case repositoryDeallocated
    case parsingError(Error)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .userNotAuthenticated:
            return "User is not authenticated"
        case .repositoryDeallocated:
            return "Repository was deallocated during operation"
        case .parsingError(let error):
            return "Failed to parse event data: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error occurred: \(error.localizedDescription)"
        }
    }
}

// MARK: - Repository Implementation
final class FirebaseEventRepository: EventFetchable {
    private let database: DatabaseReference
    private let userManager: UserManagerProtocol
    private let userDefaults: UserDefaultsManager
    
    init(
        database: DatabaseReference = Database.database().reference(),
        userManager: UserManagerProtocol = UserManager(),
        userDefaults: UserDefaultsManager = .shared
    ) {
        self.database = database
        self.userManager = userManager
        self.userDefaults = userDefaults
    }
    
    func fetchEvents(pageSize: UInt, lastKey: String?) async throws -> [Event] {
        guard let userId = userDefaults.getUserId() else {
            throw RepositoryError.userNotAuthenticated
        }
        
        let user = try await userManager.getUser(by: userId)
        let likedEventIds = user.likedEventIds
        
        return try await withCheckedThrowingContinuation { continuation in
            var query = database.child("events")
                .queryOrderedByKey()
                .queryLimited(toFirst: pageSize)
            
            if let lastKey = lastKey {
                // ვიწყებთ ბოლო key-ის შემდეგიდან
                query = query.queryStarting(afterValue: lastKey)
            }
            
            query.observeSingleEvent(of: .value) { [weak self] snapshot in
                guard let self = self else {
                    continuation.resume(throwing: RepositoryError.repositoryDeallocated)
                    return
                }
                
                var events: [Event] = []
                
                for child in snapshot.children {
                    guard let snap = child as? DataSnapshot,
                          let dict = snap.value as? [String: Any] else { continue }
                    
                    do {
                        var event = try self.parseEvent(dict: dict)
                        event.isFavorite = likedEventIds.contains(event.id)
                        events.append(event)
                    } catch {
                        print("Failed to parse event: \(error.localizedDescription)")
                    }
                }
                
                continuation.resume(returning: events)
            } withCancel: { error in
                continuation.resume(throwing: RepositoryError.networkError(error))
            }
        }
    }
    
    func fetchEventsByCategory(_ category: EventType) async throws -> [Event] {
        guard let userId = userDefaults.getUserId() else {
            throw RepositoryError.userNotAuthenticated
        }
        
        let user = try await userManager.getUser(by: userId)
        let likedEventIds = user.likedEventIds
        
        return try await withCheckedThrowingContinuation { continuation in
            database.child("events")
                .observeSingleEvent(of: .value) { [weak self] snapshot in
                    guard let self = self else {
                        continuation.resume(throwing: RepositoryError.repositoryDeallocated)
                        return
                    }
                    
                    var events: [Event] = []
                    
                    for child in snapshot.children {
                        guard let snap = child as? DataSnapshot,
                              let dict = snap.value as? [String: Any] else {
                            continue
                        }
                        
                        do {
                            var event = try self.parseEvent(dict: dict)
                            if event.type == category {
                                event.isFavorite = likedEventIds.contains(event.id)
                                events.append(event)
                            }
                        } catch {
                            print("Failed to parse event: \(error.localizedDescription)")
                            continue
                        }
                    }
                    
                    continuation.resume(returning: events)
                    
                } withCancel: { error in
                    continuation.resume(throwing: RepositoryError.networkError(error))
                }
        }
    }
    
    private func parseEvent(dict: [String: Any]) throws -> Event {
        do {
            let data = try JSONSerialization.data(withJSONObject: dict)
            return try JSONDecoder().decode(Event.self, from: data)
        } catch {
            throw RepositoryError.parsingError(error)
        }
    }
}
