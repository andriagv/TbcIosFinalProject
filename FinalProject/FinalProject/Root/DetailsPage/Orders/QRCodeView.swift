//
//  QRCodeView.swift
//  FinalProject
//
//  Created by Apple on 26.01.25.
//

import SwiftUI

import SwiftUI

struct QRCodeView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: QRCodeViewModel
    
    init(event: Event) {
        _viewModel = StateObject(wrappedValue: QRCodeViewModel(event: event))
    }
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text("დახურვა")
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            
            Text(viewModel.event.name)
                .font(.system(size: 24, weight: .bold))
                .multilineTextAlignment(.center)
            
            Text(viewModel.event.date.startDate)
                .foregroundColor(.secondary)
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(radius: 8)
                    .frame(width: 250, height: 250)
                
                if let qrImage = viewModel.qrImage {
                    Image(uiImage: qrImage)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                } else {
                    ProgressView()
                        .frame(width: 200, height: 200)
                }
            }
            
            Text("$\(viewModel.event.price.startPrice, specifier: "%.2f")")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.blue)
            
            Spacer()
        }
        .padding()
        .task {
            await viewModel.generateAndUploadQR()
        }
    }
}
