//
//  LikedEventCard.swift
//  FinalProject
//
//  Created by Apple on 24.01.25.
//

import SwiftUI

struct LikedEventCard: View {
    @StateObject private var viewModel: LikedEventCardViewModel
    
    init(event: Event, onUnlike: @escaping () -> Void, onCardTap: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: LikedEventCardViewModel(
            event: event,
            onUnlike: onUnlike,
            onCardTap: onCardTap
        ))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                if let imageName = viewModel.eventImageName {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                }
                
                Button(action: viewModel.handleUnlike) {
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
                Text(viewModel.eventName)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                HStack {
                    Label(
                        viewModel.eventAddress,
                        systemImage: "mappin.circle.fill"
                    )
                    .foregroundColor(.secondary)
                }
                
                HStack {
                    Label(
                        viewModel.formattedDate,
                        systemImage: "calendar"
                    )
                    
                    Spacer()
                    
                    PriceView(
                        originalPrice: viewModel.priceDisplay.originalPrice,
                        discountedPrice: viewModel.priceDisplay.discountedPrice
                    )
                }
                .foregroundColor(.secondary)
            }
            .padding()
            .background(.tableCellBackground)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .onTapGesture(perform: viewModel.handleCardTap)
    }
}
