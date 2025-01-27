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
    
    private let homePageCache = NSCache<NSString, UIImage>()
    private let detailsPageCache = NSCache<NSString, UIImage>()
    private let profilePageCache = NSCache<NSString, UIImage>()
    private let searchPageCache = NSCache<NSString, UIImage>()
    
    enum CacheType {
        case homePage
        case detailsPage
        case profilePage
        case searchPage
    }
    
    private init() {
        homePageCache.countLimit = 50
        detailsPageCache.countLimit = 50
        profilePageCache.countLimit = 30
        searchPageCache.countLimit = 40
        
        homePageCache.totalCostLimit = 50 * 1024 * 1024
        detailsPageCache.totalCostLimit = 50 * 1024 * 1024
        profilePageCache.totalCostLimit = 20 * 1024 * 1024
        searchPageCache.totalCostLimit = 40 * 1024 * 1024
    }
    
    private func getCache(for type: CacheType) -> NSCache<NSString, UIImage> {
        switch type {
        case .homePage:
            return homePageCache
        case .detailsPage:
            return detailsPageCache
        case .profilePage:
            return profilePageCache
        case .searchPage:
            return searchPageCache
        }
    }
    
    func fetchPhoto(photoName: String, cacheType: CacheType) async throws -> UIImage? {
        let cache = getCache(for: cacheType)
        
        let fullPhotoName = photoName.contains(".") ? photoName : photoName + ".jpg"
        
        if let cachedImage = cache.object(forKey: NSString(string: fullPhotoName)) {
            return cachedImage
        }
        
        do {
            let storageRef = Storage.storage().reference().child(fullPhotoName)
            let url = try await storageRef.downloadURL()
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let image = UIImage(data: data) {
                cache.setObject(image, forKey: NSString(string: fullPhotoName))
                return image
            }
        } catch {
            let extensions = ["jpg", "jpeg", "png", "webp"]
            for ext in extensions {
                let alternativePhotoName = photoName.replacingOccurrences(of: "\\.[^.]+$", with: "", options: .regularExpression) + "." + ext
                
                do {
                    let alternativeRef = Storage.storage().reference().child(alternativePhotoName)
                    let url = try await alternativeRef.downloadURL()
                    let (data, _) = try await URLSession.shared.data(from: url)
                    
                    if let image = UIImage(data: data) {
                        cache.setObject(image, forKey: NSString(string: alternativePhotoName))
                        return image
                    }
                } catch {
                    continue
                }
            }
            
            print("Failed to load image \(photoName): \(error.localizedDescription)")
            throw error
        }
        return nil
    }
    
    func clearCache(for type: CacheType) {
        let cache = getCache(for: type)
        cache.removeAllObjects()
    }
    
    func clearAllCaches() {
        homePageCache.removeAllObjects()
        detailsPageCache.removeAllObjects()
        profilePageCache.removeAllObjects()
        searchPageCache.removeAllObjects()
    }
}
