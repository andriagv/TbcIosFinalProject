//
//  MapViewModel.swift
//  FinalProject
//
//  Created by Apple on 28.01.25.
//


import Foundation
import FirebaseDatabase

protocol MapViewModelProtocol {
    var eventsPublisher: Published<[Event]>.Publisher { get }
    func loadEvents()
}

final class MapViewModel: MapViewModelProtocol, ObservableObject {
    @Published private(set) var events: [Event] = []
    var eventsPublisher: Published<[Event]>.Publisher { $events }
    
    private let databaseRef = Database.database().reference()
    
    func loadEvents() {
        databaseRef.child("events")
            .observeSingleEvent(of: .value) { snapshot in
                var loadedEvents: [Event] = []
                
                for child in snapshot.children {
                    guard let snapshot = child as? DataSnapshot,
                          let dict = snapshot.value as? [String: Any] else { continue }
                    
                    do {
                        let data = try JSONSerialization.data(withJSONObject: dict)
                        if let event = try? JSONDecoder().decode(Event.self, from: data) {
                            loadedEvents.append(event)
                        }
                    } catch {
                        print("Parsing error: \(error)")
                    }
                }
                
                DispatchQueue.main.async {
                    self.events = loadedEvents
                }
            }
    }
}
