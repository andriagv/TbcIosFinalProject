//
//  HomePageViewModel.swift
//  FinalProject
//
//  Created by Apple on 12.01.25.
//

import Foundation
import Firebase

protocol HomePageViewModelProtocol: AnyObject {
    var events: [Event] { get }
    var forYouEvents: [Event] { get }
    var onDataLoaded: (() -> Void)? { get set }
    func loadEvents()
}

final class HomePageViewModel: HomePageViewModelProtocol {
    
    private(set) var events: [Event] = []
    
    private(set) var forYouEvents: [Event] = []
    
    var onDataLoaded: (() -> Void)?
    
    init() {
        loadEvents()
    }
    
    internal func loadEvents() {
        guard let url = Bundle.main.url(forResource: "mock", withExtension: "json") else {
            print("JSON ფაილი ვერ მოიძებნა")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decodedResponse = try JSONDecoder().decode(EventsResponse.self, from: data)
            let allEvents = decodedResponse.events

            DispatchQueue.main.async {
                self.events = allEvents
                self.forYouEvents = self.events.filter { !$0.isFavorite }
                self.onDataLoaded?()
            }
        } catch {
            print("მონაცემების ჩატვირთვის შეცდომა: \(error.localizedDescription)")
        }
    }
}
