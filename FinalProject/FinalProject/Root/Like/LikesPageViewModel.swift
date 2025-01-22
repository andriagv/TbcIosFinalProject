//
//  LikesPageViewModel.swift
//  FinalProject
//
//  Created by Apple on 12.01.25.
//

import Foundation

protocol LikesPageViewModelProtocol {
    var likedEvents: [Event] { get }
    var onLikedDataLoaded: (() -> Void)? { get set }

    func loadLikedEvents()
}

final class LikesPageViewModel: LikesPageViewModelProtocol {

    // MARK: - Properties

    private(set) var likedEvents: [Event] = []

    var onLikedDataLoaded: (() -> Void)?

    // MARK: - Init
    init() {
        loadLikedEvents()
    }

    // MARK: - Public Methods

    func loadLikedEvents() {
        guard let url = Bundle.main.url(forResource: "mockLikedEvents", withExtension: "json") else {
            print("mockLikedEvents.json ფაილი ვერ მოიძებნა.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decodedContainer = try decoder.decode(EventsContainer.self, from: data)

            self.likedEvents = decodedContainer.events.filter { $0.isFavorite }

            onLikedDataLoaded?()

        } catch {
            print("JSON Data Parsing Error: \(error.localizedDescription)")
        }
    }
}
