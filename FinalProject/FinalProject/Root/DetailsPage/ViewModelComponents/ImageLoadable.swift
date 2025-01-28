//
//  ImageLoadable.swift
//  FinalProject
//
//  Created by Apple on 29.01.25.
//


import Foundation
import UIKit

// MARK: - Protocols
protocol ImageLoadable {
    func loadImage(photoName: String) async throws -> UIImage?
}

// MARK: - Implementations
final class EventImageLoader: ImageLoadable {
    func loadImage(photoName: String) async throws -> UIImage? {
        try await ImageCacheManager.shared.fetchPhoto(
            photoName: photoName,
            cacheType: .detailsPage
        )
    }
}
