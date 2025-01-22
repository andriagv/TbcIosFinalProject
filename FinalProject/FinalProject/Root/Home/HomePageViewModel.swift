//
//  HomePageViewModel.swift
//  FinalProject
//
//  Created by Apple on 12.01.25.
//

import Foundation

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
    
    // MARK: - Properties
    
    private(set) var events: [Event] = []
    private(set) var forYouEvents: [Event] = []
    
    var onDataLoaded: (() -> Void)?
    
    // MARK: - Init
    init() {
        loadData()
    }
    
    // MARK: - Public Methods
    
    func loadData() {
        guard let url = Bundle.main.url(forResource: "mockEvents", withExtension: "json") else {
            print("mockEvents.json ფაილი ვერ მოიძებნა.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decodedContainer = try decoder.decode(EventsContainer.self, from: data)
            
            self.events = decodedContainer.events
            
            self.forYouEvents = events.filter { $0.price.discountedPrice != nil }
            
            onDataLoaded?()
            
        } catch {
            print("JSON Data Parsing Error: \(error.localizedDescription)")
        }
    }
}
