//
//  TabBarController.swift
//  fin_hel
//
//  Created by Apple on 31.12.24.
//


import UIKit
import SwiftUI

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = HomePageViewController()
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

