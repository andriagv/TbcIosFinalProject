//
//  TicketsViewControllerRepresentable.swift
//  FinalProject
//
//  Created by Apple on 26.01.25.
//


import SwiftUI
import UIKit

struct TicketsViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> TicketsViewController {
        return TicketsViewController()
    }
    
    func updateUIViewController(_ uiViewController: TicketsViewController, context: Context) {}
}
