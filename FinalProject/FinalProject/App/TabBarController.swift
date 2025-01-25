//
//  TabBarController.swift
//  fin_hel
//
//  Created by Apple on 31.12.24.
//


import UIKit
import SwiftUI

final class TabBarController: UITabBarController {
    let languageManager = LanguageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        
        if let savedLanguage = UserDefaults.standard.stringArray(forKey: "AppleLanguages")?.first {
            Bundle.setLanguage(savedLanguage)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let vcs = viewControllers {
            vcs[0].tabBarItem.title = "Home".localized()
            vcs[1].tabBarItem.title = "Search".localized()
            vcs[2].tabBarItem.title = "Likes".localized()
            vcs[3].tabBarItem.title = "Profile".localized()
        }
    }
    
    private func setupViewControllers() {
        let homePageVC = HomePageViewController()
        let homeVC = UINavigationController(rootViewController: homePageVC)
        homeVC.tabBarItem = UITabBarItem(
            title: "Home".localized(),
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        let searchView = SearchView()
        let searchVC = UIHostingController(rootView: searchView)
        searchVC.tabBarItem = UITabBarItem(
            title: "Search".localized(),
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
        
        let likesView = LikesPageView()
        let likesVC = UIHostingController(rootView: likesView)
        likesVC.tabBarItem = UITabBarItem(
            title: "Likes".localized(),
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        let profileView = ProfileView()
        let profileVC = UIHostingController(rootView: profileView)
        profileVC.tabBarItem = UITabBarItem(
            title: "Profile".localized(),
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        self.viewControllers = [homeVC, searchVC, likesVC, profileVC]
    }
}


#Preview {
    TabBarController()
}
