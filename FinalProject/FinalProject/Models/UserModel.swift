//
//  UserModel.swift
//  FinalProject
//
//  Created by Apple on 23.01.25.
//


import Foundation
import FirebaseFirestore

struct UserModel: Identifiable, Decodable {
    @DocumentID var id: String?
    let uid: String
    let email: String
    let fullName: String
    let username: String
    let createdAt: Date
    let photoUrl: String
}