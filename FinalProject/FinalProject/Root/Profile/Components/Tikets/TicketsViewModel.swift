//
//  TicketsViewModel.swift
//  FinalProject
//
//  Created by Apple on 26.01.25.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore

protocol TicketsViewModelDelegate: AnyObject {
    func didLoadEvents(_ events: [Event])
    func didFailWithError(_ error: Error)
}

class TicketsViewModel {
    weak var delegate: TicketsViewModelDelegate?
    private let databaseRef = Database.database().reference()
    private(set) var orderedEvents: [Event] = []

    func fetchUserEvents() {
        print("🔍 Fetching user events...")

        guard let userId = UserDefaultsManager.shared.getUserId() else {
            print("User ID not found")
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                self.delegate?.didFailWithError(error)
                return
            }

            guard let userData = snapshot?.data(),
                  let orderedEventIds = userData["orderedEvents"] as? [String] else {
                print("No `orderedEvents` field found or it's not an array of strings")
                return
            }

            print("Ordered events: \(orderedEventIds)")

            self.fetchEvents(fromIds: orderedEventIds)
        }
    }

    private func fetchEvents(fromIds ids: [String]) {
        print("Fetching all events from Realtime Database...")

        databaseRef.child("events").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }

            print("Events snapshot: \(String(describing: snapshot.value))")

            guard let eventsArray = snapshot.value as? [[String: Any]] else {
                print("Events data is not in expected format or is missing")
                return
            }

            print("All events fetched successfully.")

            do {
                let filteredEvents = try eventsArray.compactMap { eventDict -> Event? in
                    guard let eventId = eventDict["id"] as? String, ids.contains(eventId) else {
                        return nil
                    }

                    let eventData = try JSONSerialization.data(withJSONObject: eventDict)
                    return try JSONDecoder().decode(Event.self, from: eventData)
                }

                print("Filtered events: \(filteredEvents)")

                DispatchQueue.main.async {
                    self.orderedEvents = filteredEvents
                    self.delegate?.didLoadEvents(filteredEvents)
                }
            } catch {
                print("Error decoding events: \(error)")
                self.delegate?.didFailWithError(error)
            }
        }
    }

}
