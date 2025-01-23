//
//  SmallButtonView.swift
//  FinalProject
//
//  Created by Apple on 21.01.25.
//

import SwiftUI

struct SmallButtonView: View {
    let imageSystemName: String
    let fontSize: CGFloat
    var body: some View {
        Image(systemName: imageSystemName)
            .font(.system(size: fontSize))
            //.foregroundColor(.white)
            .padding(8)
            .background(.ultraThinMaterial)
            .clipShape(Circle())
    }
}

#Preview {
    //SmallButtonView(imageSystemName: "heart.fill", fontSize: 30)
    SearchView()
}

