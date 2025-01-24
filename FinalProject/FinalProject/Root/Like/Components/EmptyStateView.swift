//
//  EmptyStateView.swift
//  FinalProject
//
//  Created by Apple on 24.01.25.
//

import SwiftUI


struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("ფავორიტები ცარიელია")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("დაამატეთ ღონისძიებები ფავორიტებში")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    EmptyStateView()
}
