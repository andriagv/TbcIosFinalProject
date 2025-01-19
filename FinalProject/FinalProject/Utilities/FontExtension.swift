//
//  FontExtension.swift
//  FinalProject
//
//  Created by Apple on 19.01.25.
//

import Foundation
import SwiftUI


extension Font {
    static func dateNumberFont(size: CGFloat) -> Font {
        return Font.custom("PlusJakartaSans-MediumItalic", size: size)
    }
    
    static func dateNumberFontBold(size: CGFloat) -> Font {
        return Font.custom("PlusJakartaSans-BoldItalic", size: size)
    }
    
    static func titleFontBold(size: CGFloat) -> Font {
        return Font.custom("PlusJakartaSans-SemiBold", size: size)
    }
    
}
