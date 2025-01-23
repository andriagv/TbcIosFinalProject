//
//  AppDelegate.swift
//  FinalProject
//
//  Created by Apple on 12.01.25.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Firebase-ის კონფიგურაცია
        FirebaseApp.configure()
        
        // *** აქ არაფერს ვუშვებთ GoogleSignIn-ის clientID-ზე
        // რადგან ახალი ვერსია ავტომატურად წაიღებს Client ID–ს Info.plist–იდან (GIDClientID ველს).

        return true
    }

    // Deep Link / URL Schemes (Google Sign-In უკანა გამოძახება)
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
