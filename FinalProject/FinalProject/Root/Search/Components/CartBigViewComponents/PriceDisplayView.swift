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
                
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundStyle(Color.green)
                    .font(.system(size: 22))
            }
            
            if let discountedPrice = discountedPrice {
                VStack(alignment: .leading, spacing: 4) {
                    Text("$\(startPrice, specifier: "%.2f")")
                        .strikethrough(showDiscount, color: .red)
                        .foregroundStyle(Color.red)
                        .font(.system(size: 14, weight: .medium))
                        .opacity(0.8)
                    
                    HStack(alignment: .center, spacing: 8) {
                        Text("$\(discountedPrice, specifier: "%.2f")")
                            .foregroundStyle(Color.green)
                            .font(.system(size: 22, weight: .bold))
                        Text("\(calculateDiscount(original: startPrice, discounted: discountedPrice))% OFF")
                            .font(.system(size: 12, weight: .bold))
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
                    .font(.system(size: 22, weight: .bold))
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

// Preview provider for testing
struct PriceDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Regular price
            PriceDisplayView(startPrice: 99.99, discountedPrice: nil)
            
            // Discounted price
            PriceDisplayView(startPrice: 99.99, discountedPrice: 79.99)
        }
        .padding()
    }
}

// Usage in your existing view
struct YourExistingView: View {
    let event: Event // Your event model
    
    var body: some View {
        PriceDisplayView(
            startPrice: event.price.startPrice,
            discountedPrice: event.price.discountedPrice
        )
    }
}
