//
//  TabBarController.swift
//  fin_hel
//
//  Created by Apple on 31.12.24.
//


import UIKit
import SwiftUI

final class TabBarController: UITabBarController {
    private let ellipticalBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 35
        view.layer.masksToBounds = true
        view.backgroundColor = .tabBar
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlurEffect()
        setupTabBar()
        setupViewControllers()
    }
    
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = tabBar.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        ellipticalBackground.addSubview(blurView)
        view.insertSubview(ellipticalBackground, belowSubview: tabBar)
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }

    private func setupTabBar() {
        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .clear
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let tabBarHeight: CGFloat = 70
        let bottomPadding = view.safeAreaInsets.bottom
        
        let frameWidth = view.frame.width - 32
        let frameX = (view.frame.width - frameWidth) / 2
        let frameY = view.frame.height - tabBarHeight - bottomPadding + 10
        
        let customFrame = CGRect(
            x: frameX,
            y: frameY,
            width: frameWidth,
            height: tabBarHeight
        )
        
        ellipticalBackground.frame = customFrame
    }
    
    private func setupViewControllers() {
        let homePageVC = HomePageViewController()
        let homeVC = UINavigationController(rootViewController: homePageVC)
        homeVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        let searchView = SearchView()
        let searchVC = UIHostingController(rootView: searchView)
        searchVC.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
        
        let likesVC = LikesPageViewController()
        likesVC.tabBarItem = UITabBarItem(
            title: "Likes",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        let profileView = ProfileView()
        let profileVC = UIHostingController(rootView: profileView)
        profileVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        self.viewControllers = [homeVC, searchVC, likesVC, profileVC]
    }
}

#Preview {
    TabBarController()
}
