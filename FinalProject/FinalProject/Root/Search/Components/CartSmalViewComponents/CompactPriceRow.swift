//
//  CompactPriceRow.swift
//  FinalProject
//
//  Created by Apple on 19.01.25.
//

import SwiftUI

struct CompactPriceRow: View {
    let startPrice: Double
    let discountedPrice: Double?
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "dollarsign.circle")
                .foregroundStyle(Color.blue)
                .font(.system(size: 12))
            
            if let discountedPrice = discountedPrice {
                HStack(alignment: .center, spacing: 5) {
                    Text("$\(startPrice, specifier: "%.2f")")
                        .strikethrough(true, color: .red)
                        .foregroundStyle(Color.red)
                        .font(.dateNumberFont(size: 10))
                    
                    Text("$\(discountedPrice, specifier: "%.2f")")
                        .foregroundStyle(Color.green)
                        .font(.dateNumberFontBold(size: 13))
                }
            } else {
                Text("$\(startPrice, specifier: "%.2f")")
                    .foregroundStyle(Color.primary)
                    .font(.titleFontBold(size: 13))
            }
            
            Spacer(minLength: 0)
        }
    }
}


#Preview {
    SearchView { _ in }
}
