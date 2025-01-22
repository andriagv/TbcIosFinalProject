//
//  ContactUsViewControllerRepresentable.swift
//  FinalProject
//
//  Created by Apple on 19.01.25.
//


import SwiftUI
import UIKit

// MARK: - ContactUsViewControllerRepresentable
struct ContactUsViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ContactUsViewController {
        ContactUsViewController()
    }
    
    func updateUIViewController(_ uiViewController: ContactUsViewController, context: Context) {
        
    }
}

// MARK: - PrivacyPolicyViewControllerRepresentable
struct PrivacyPolicyViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> PrivacyPolicyViewController {
        PrivacyPolicyViewController()
    }
    
    func updateUIViewController(_ uiViewController: PrivacyPolicyViewController, context: Context) {
    }
}

// MARK: - TermsAndConditionsViewControllerRepresentable
struct TermsAndConditionsViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> TermsAndConditionsViewController {
        TermsAndConditionsViewController()
    }
    
    func updateUIViewController(_ uiViewController: TermsAndConditionsViewController, context: Context) {
    }
}
