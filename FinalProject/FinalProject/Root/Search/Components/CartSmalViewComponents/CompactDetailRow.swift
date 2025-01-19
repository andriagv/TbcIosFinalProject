//
//  CompactDetailRow.swift
//  FinalProject
//
//  Created by Apple on 19.01.25.
//

import SwiftUI

struct CompactDetailRow: View {
    let icon: String
    let iconColor: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundStyle(iconColor)
                .font(.system(size: 12))
            
            Text(text)
                .font(.titleFontBold(size: 13))                .foregroundStyle(Color.primary)
                .lineLimit(1)
            
            Spacer(minLength: 0)
        }
    }
}

#Preview() {
    SearchView()
}
