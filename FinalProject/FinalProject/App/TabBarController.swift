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
    private var lastSelectedIndex = 0
    private var panGesture: UIPanGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        addSwipeNavigation()
        
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
    
    private func addSwipeNavigation() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        if let panGesture = panGesture {
            view.addGestureRecognizer(panGesture)
        }
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        _ = gesture.translation(in: view).x
        
        if gesture.state == .ended {
            let velocity = gesture.velocity(in: view).x
            if velocity > 0 && selectedIndex > 0 {
                selectedIndex -= 1
            } else if velocity < 0 && selectedIndex < (viewControllers?.count ?? 1) - 1 {
                selectedIndex += 1
            }
        }
    }
    
    private func setupViewControllers() {
        let homePageVC = MainViewController()
        let homeNav = UINavigationController(rootViewController: homePageVC)
        homeNav.tabBarItem = UITabBarItem(
            title: "Home".localized(),
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        let searchNav = UINavigationController()
        searchNav.tabBarItem = UITabBarItem(
            title: "Search".localized(),
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
        
        let searchView = SearchView { [weak searchNav] event in
            guard let searchNav = searchNav else { return }
            let detailsVC = UIHostingController(rootView: EventDetailsView(event: event))
            detailsVC.hidesBottomBarWhenPushed = true
            searchNav.pushViewController(detailsVC, animated: true)
        }
        let searchHosting = UIHostingController(rootView: searchView)
        searchNav.viewControllers = [searchHosting]
        
        let likesNav = UINavigationController()
        likesNav.tabBarItem = UITabBarItem(
            title: "Likes".localized(),
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        let likesView = LikesPageView { [weak likesNav] event in
            guard let likesNav = likesNav else { return }
            let detailsVC = UIHostingController(rootView: EventDetailsView(event: event))
            detailsVC.hidesBottomBarWhenPushed = true
            likesNav.pushViewController(detailsVC, animated: true)
        }
        let likesHosting = UIHostingController(rootView: likesView)
        likesNav.viewControllers = [likesHosting]
        
        let profileView = ProfileView()
        let profileHosting = UIHostingController(rootView: profileView)
        profileHosting.tabBarItem = UITabBarItem(
            title: "Profile".localized(),
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        self.viewControllers = [homeNav, searchNav, likesNav, profileHosting]
    }
    
    deinit {
        if let panGesture = panGesture {
            view.removeGestureRecognizer(panGesture)
        }
        print("TabBarController deinitialized")
    }
}

#Preview {
    TabBarController()
}
