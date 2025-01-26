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
    
    init(event: Event) {
        self.event = event
    }
    
    func generateAndUploadQR() async {
        guard let userId = UserDefaultsManager.shared.getUserId() else { return }
        let qrString = "\(userId)\(event.id)"
        guard let qrImage = QRCodeManager.generateQRCode(from: qrString) else { return }
        
        await MainActor.run {
            self.qrImage = qrImage
        }
        
        try? await updateUserOrderedEvents(userId: userId, qrString: qrString)
    }
    
    private func updateUserOrderedEvents(userId: String, qrString: String) async throws {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        try await userRef.updateData([
            "orderedEvents": FieldValue.arrayUnion([event.id])
        ])
    }
}
