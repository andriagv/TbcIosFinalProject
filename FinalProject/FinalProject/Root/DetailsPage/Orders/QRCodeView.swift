//
//  QRCodeView.swift
//  FinalProject
//
//  Created by Apple on 26.01.25.
//


import SwiftUI

struct QRCodeView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: QRCodeViewModel
    @State private var isQRVisible = false
    
    init(event: Event) {
        _viewModel = StateObject(wrappedValue: QRCodeViewModel(event: event))
    }
    
    var body: some View {
        VStack(spacing: 24) {
            closeButton
            eventDetails
            qrCodeView
            priceView
            Spacer()
        }
        .padding()
        .task {
            await viewModel.generateAndUploadQR()
            withAnimation {
                isQRVisible = true
            }
        }
        .background(.pageBack)
    }
    
    private var closeButton: some View {
        HStack {
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding()
            }
        }
    }
    
    private var eventDetails: some View {
        VStack(spacing: 12) {
            Text(viewModel.event.name)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text(viewModel.event.date.startDate)
                .foregroundColor(.secondary)
                .font(.subheadline)
        }
        .opacity(isQRVisible ? 1 : 0)
        .animation(.easeIn(duration: 0.3), value: isQRVisible)
    }
    
    private var qrCodeView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
                .frame(width: 280, height: 280)
            
            if let qrImage = viewModel.qrImage {
                Image(uiImage: qrImage)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 220)
                    .opacity(isQRVisible ? 1 : 0)
                    .animation(.easeIn(duration: 0.5).delay(0.2), value: isQRVisible)
            } else {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(width: 220, height: 220)
            }
        }
        .padding(.vertical)
    }
    
    private var priceView: some View {
        Text("$\(viewModel.event.price.startPrice, specifier: "%.2f")")
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.blue)
            .padding(.vertical, 8)
            .padding(.horizontal, 24)
            .background(
                Capsule()
                    .fill(Color.blue.opacity(0.1))
            )
            .opacity(isQRVisible ? 1 : 0)
            .animation(.easeIn(duration: 0.3).delay(0.4), value: isQRVisible)
    }
}


#Preview() {
    QRCodeView(event: Event(
        id: UUID().uuidString,
        name: "ulamazesi usba",
        type: .hiking,
        price: Price(startPrice: 20.0, discountedPrice: nil),
        date: EventDate(startDate: "2025-03-05", endDate: "2025-03-05", durationInDays: 1),
        location: Location(latitude: 41.7151, longitude: 44.8271, address: "Mtatsminda Park", city: "svaneti"),
        seats: Seats(total: 30, available: 15),
        photos: ["banaki1"],
        organizerContact: "hikegeorgia@gmail.com",
        requirements: ["Comfortable Shoes"],
        tags: ["City", "Adventure"],
        isFavorite: true,
        description: "Experience the beauty of Tbilisi with a guided hiking tour."
    ))
}
