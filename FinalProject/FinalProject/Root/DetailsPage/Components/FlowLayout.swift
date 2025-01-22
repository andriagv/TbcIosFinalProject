//
//  FlowLayout.swift
//  FinalProject
//
//  Created by Apple on 21.01.25.
//

import SwiftUI

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? 0
        var height: CGFloat = 0
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(proposal)
            
            if currentX + size.width > maxWidth {
                currentX = 0
                currentY += size.height + spacing
            }
            
            currentX += size.width + spacing
            height = max(height, currentY + size.height)
        }
        
        return CGSize(width: maxWidth, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var currentX = bounds.minX
        var currentY = bounds.minY
        
        for subview in subviews {
            let size = subview.sizeThatFits(proposal)
            
            if currentX + size.width > bounds.maxX {
                currentX = bounds.minX
                currentY += size.height + spacing
            }
            
            subview.place(
                at: CGPoint(x: currentX, y: currentY),
                proposal: ProposedViewSize(size)
            )
            currentX += size.width + spacing
        }
    }
}
