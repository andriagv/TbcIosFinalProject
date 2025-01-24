//
//  UserModel.swift
//  FinalProject
//
//  Created by Apple on 23.01.25.
//


import Foundation
import FirebaseFirestore


struct UserModel: Identifiable, Codable {
    var id: String? 
    let uid: String
    let email: String
    let fullName: String
    let username: String
    let createdAt: Date
    let photoUrl: String
    var likedEventIds: [String]
    var orderedEvents: [OrderedEvent]
}
