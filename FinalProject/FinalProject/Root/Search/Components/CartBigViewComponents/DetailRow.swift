//
//  DetailRow.swift
//  FinalProject
//
//  Created by Apple on 19.01.25.
//

import SwiftUI

struct DetailRow: View {
    let icon: String
    let iconColor: Color
    let text: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 36, height: 36)
                    
                Image(systemName: icon)
                    .foregroundStyle(iconColor)
                    .font(.system(size: 20))
            }
            Text(text)
                .font(.titleFontBold(size: 16))
                .foregroundStyle(Color.primary)
            Spacer()
        }
    }
}


#Preview {
    SearchView { _ in }
}
