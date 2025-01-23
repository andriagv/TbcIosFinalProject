//
//  ButtonModifier.swift
//  FinalProject
//
//  Created by Apple on 23.01.25.
//


import SwiftUI

struct ButtonModifier: ViewModifier {
    let tintColor: Color
    let backgroundColor: Color
    var width: CGFloat
    var height: CGFloat
    
    func body(content: Content) -> some View {
        content
            .frame(width: width, height: height)
            .background(backgroundColor)
            .cornerRadius(12)
            .foregroundColor(tintColor)
    }
}

extension View {
    func makeButtonStyle(tintColor: Color, backgroundColor: Color, width: CGFloat, height: CGFloat) -> some View {
        self.modifier(ButtonModifier(tintColor: tintColor, backgroundColor: backgroundColor, width: width, height: height))
    }
}