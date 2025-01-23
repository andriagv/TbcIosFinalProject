//
//  PriceDisplayView.swift
//  FinalProject
//
//  Created by Apple on 19.01.25.
//

import SwiftUI

struct PriceDisplayView: View {
    let startPrice: Double
    let discountedPrice: Double?
    
    @State private var showDiscount: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 36, height: 36)
                
                Image(systemName: "dollarsign.circle")
                    .font(.system(size: 22))
            }
            
            if let discountedPrice = discountedPrice {
                VStack(alignment: .leading, spacing: 4) {
                    Text("$\(startPrice, specifier: "%.2f")")
                        .strikethrough(showDiscount, color: .red)
                        .foregroundStyle(Color.red)
                        .font(.dateNumberFontBold(size: 14))
                        .opacity(0.8)
                    
                    HStack(alignment: .center, spacing: 8) {
                        Text("$\(discountedPrice, specifier: "%.2f")")
                            .foregroundStyle(Color.green)
                            .font(.dateNumberFontBold(size: 22))
                        Text("\(calculateDiscount(original: startPrice, discounted: discountedPrice))% OFF")
                            .font(.dateNumberFontBold(size: 22))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(Color.red)
                            )
                    }
                }
            } else {
                Text("$\(startPrice, specifier: "%.2f")")
                    .foregroundStyle(Color.primary)
                    .font(.titleFontBold(size: 22))
            }
            
            Spacer()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.3).delay(0.2)) {
                showDiscount = true
            }
        }
    }
    
    private func calculateDiscount(original: Double, discounted: Double) -> Int {
        let savings = ((original - discounted) / original) * 100
        return Int(round(savings))
    }
}


#Preview() {
    SearchView()
}
