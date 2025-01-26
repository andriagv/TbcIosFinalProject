//
//  QRCodeViewModel.swift
//  FinalProject
//
//  Created by Apple on 26.01.25.
//

import Foundation
import UIKit
import Firebase


class QRCodeViewModel: ObservableObject {
    let event: Event
    @Published var qrImage: UIImage?
    @Published var showConfirmationAlert = false
    @Published var seatsAvailable: Int
    
    init(event: Event) {
        self.event = event
        self.seatsAvailable = event.seats.available
    }
    
    func generateAndUploadQR() async {
        guard let userId = UserDefaultsManager.shared.getUserId() else { return }
        let qrString = "\(userId)\(event.id)"
        guard let qrImage = QRCodeManager.generateQRCode(from: qrString) else { return }
        
        await MainActor.run {
            self.qrImage = qrImage
        }
        
        do {
            try await updateUserOrderedEvents(userId: userId)
            try await updateSeatsAvailable()
        } catch {
            print("Error updating: \(error)")
        }
    }
    
    private func updateUserOrderedEvents(userId: String) async throws {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        try await userRef.updateData([
            "orderedEvents": FieldValue.arrayUnion([event.id])
        ])
    }
    
    private func updateSeatsAvailable() async throws {
        let databaseRef = Database.database().reference()
        let eventRef = databaseRef.child("events")
        
        let snapshot = try await eventRef.getData()
        guard var eventsArray = snapshot.value as? [[String: Any]] else { return }
        
        if let index = eventsArray.firstIndex(where: { ($0["id"] as? String) == event.id }) {
            eventsArray[index]["seats"] = [
                "total": event.seats.total,
                "available": seatsAvailable - 1
            ]
            try await eventRef.setValue(eventsArray)
            
            await MainActor.run {
                self.seatsAvailable -= 1
            }
        }
    }
}
