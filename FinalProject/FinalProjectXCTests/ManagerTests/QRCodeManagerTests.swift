//
//  QRCodeManagerTests.swift
//  FinalProject
//
//  Created by Apple on 29.01.25.
//


import XCTest
@testable import FinalProject

final class QRCodeManagerTests: XCTestCase {
    
    func testGenerateQRCode() {
        let qrCodeImage = QRCodeManager.generateQRCode(from: "QR Code")
        XCTAssertNotNil(qrCodeImage, "should return a valid image")
    }
}
