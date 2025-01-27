//
//  PriceView.swift
//  FinalProject
//
//  Created by Apple on 27.01.25.
//

import SwiftUI


struct PriceView: View {
    let originalPrice: Double
    let discountedPrice: Double?
    
    var body: some View {
        Group {
            if let discounted = discountedPrice {
                Text("$\(Int(originalPrice))")
                    .strikethrough()
                    .foregroundColor(.secondary)
                Text("$\(Int(discounted))")
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            } else {
                Text("$\(Int(originalPrice))")
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
        }
    }
}
