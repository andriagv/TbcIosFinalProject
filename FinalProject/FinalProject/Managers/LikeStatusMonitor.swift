//
//  LikeStatusMonitor.swift
//  FinalProject
//
//  Created by Apple on 24.01.25.
//

import Foundation


final class LikeStatusMonitor: ObservableObject {
    @Published var lastUpdated = Date()
    static let shared = LikeStatusMonitor()
    
    func statusChanged() {
        lastUpdated = Date()
    }
}

