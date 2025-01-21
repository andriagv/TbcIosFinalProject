//
//  InfoCard.swift
//  FinalProject
//
//  Created by Apple on 21.01.25.
//


import SwiftUI

struct InfoCard: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(.blue)
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview() {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
        InfoCard(icon: "calendar", title: "Date", value: "formatDateRange()formatDateRange())formatDateRange()")
        InfoCard(icon: "mappin", title: "Location", value: "formatLocation()")
        InfoCard(icon: "person.2.fill", title: "Availability", value: " spots left")
        InfoCard(icon: "clock", title: "Duration", value: "formatDuration()formatDuration()formatDuration()")
            
    }
}
