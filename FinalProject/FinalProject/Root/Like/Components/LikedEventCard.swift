//
//  LikedEventCard.swift
//  FinalProject
//
//  Created by Apple on 24.01.25.
//

import SwiftUI


struct LikedEventCard: View {
    let event: Event
    let onUnlike: () -> Void
    
    let onCardTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                if let imageName = event.photos.first {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                }
                
                Button(action: {
                    onUnlike()
                }) {
                    Image(systemName: "heart.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                .padding(12)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text(event.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                HStack {
                    Label(
                        event.location.address ?? "No address",
                        systemImage: "mappin.circle.fill"
                    )
                    .foregroundColor(.secondary)
                }
                
                HStack {
                    Label(
                        DateFormatterManager.shared.formatDate(event.date.startDate),
                        systemImage: "calendar"
                    )
                    
                    Spacer()
                    
                    if let discounted = event.price.discountedPrice {
                        Text("$\(Int(event.price.startPrice))")
                            .strikethrough()
                            .foregroundColor(.secondary)
                        Text("$\(Int(discounted))")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    } else {
                        Text("$\(Int(event.price.startPrice))")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                }
                .foregroundColor(.secondary)
            }
            .padding()
            .background(.tableCellBackground)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .onTapGesture {
            onCardTap()
        }
    }
}
