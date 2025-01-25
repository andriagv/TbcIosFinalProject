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
            
            Text("Favorites are empty".localized())
                .fontWeight(.medium)
                .font(.custom("SourGummy-Bold", size: 23))
            
            Text("Add events to favorites".localized())
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .font(.custom("SourGummy-Bold", size: 18))
        }
    }
}

#Preview {
    EmptyStateView()
}
