//
//  HomePageViewModel.swift
//  FinalProject
//
//  Created by Apple on 12.01.25.
//

import Foundation
import FirebaseDatabase
import Firebase

struct EventsContainer: Codable {
    let events: [Event]
}

protocol HomePageViewModelProtocol {
    var events: [Event] { get }
    var forYouEvents: [Event] { get }
    var onDataLoaded: (() -> Void)? { get set }
    
    func loadData()    
}

final class HomePageViewModel: HomePageViewModelProtocol {
    private(set) var events: [Event] = []
        private(set) var forYouEvents: [Event] = []
        var onDataLoaded: (() -> Void)?
        private let databaseRef = Database.database().reference()
    
    init() {
        loadData()
    }
    
    func loadData() {
        databaseRef.child("events").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self,
                  let value = snapshot.value as? [[String: Any]] else { return }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: value)
                let decoder = JSONDecoder()
                let events = try decoder.decode([Event].self, from: data)
                
                self.events = events
                self.forYouEvents = events.filter { $0.price.discountedPrice != nil }
                self.onDataLoaded?()
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
