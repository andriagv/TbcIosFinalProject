//
//  ImageCacheManager.swift
//  FinalProject
//
//  Created by Apple on 14.01.25.
//


import Foundation
import FirebaseStorage
import UIKit

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let imageCache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func fetchPhoto(photoName: String) async throws -> UIImage? {
        if let cachedImage = imageCache.object(forKey: NSString(string: photoName)) {
            return cachedImage
        }
        
        let storageRef = Storage.storage().reference().child(photoName)
        let url = try await storageRef.downloadURL()
        let (data, _) = try await URLSession.shared.data(from: url)
        
        if let image = UIImage(data: data) {
            imageCache.setObject(image, forKey: NSString(string: photoName))
            return image
        }
        return nil
    }
}
