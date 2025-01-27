//
//  QRCodeManager.swift
//  FinalProject
//
//  Created by Apple on 26.01.25.
//

import UIKit
import CoreImage.CIFilterBuiltins

final class QRCodeManager {
    static func generateQRCode(from string: String, scale: CGFloat = 10) -> UIImage? {
        guard let data = string.data(using: .ascii) else { return nil }
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        
        guard let ciImage = filter.outputImage else { return nil }
        
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let scaledCIImage = ciImage.transformed(by: transform)
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledCIImage, from: scaledCIImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}
