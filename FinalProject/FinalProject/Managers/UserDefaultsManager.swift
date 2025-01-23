//
//  UserDefaultsManager.swift
//  FinalProject
//
//  Created by Apple on 23.01.25.
//


import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let isUserLoggedIn = "isUserLoggedIn"
        static let userId = "userId"
    }
    
    private init() {}
    
    func setUserLoggedIn(userId: String) {
        defaults.set(true, forKey: Keys.isUserLoggedIn)
        defaults.set(userId, forKey: Keys.userId)
    }
    
    func getUserId() -> String? {
        return defaults.string(forKey: Keys.userId)
    }
    
    func isUserLoggedIn() -> Bool {
        return defaults.bool(forKey: Keys.isUserLoggedIn)
    }
    
    func logoutUser() {
        defaults.set(false, forKey: Keys.isUserLoggedIn)
        defaults.removeObject(forKey: Keys.userId)
    }
}