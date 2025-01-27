//
//  MainViewController.swift
//  FinalProject
//
//  Created by Apple on 26.01.25.
//


import UIKit
import Network

final class MainViewController: UIViewController {
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private var currentChild: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNetworkMonitoring()
    }
    
    deinit {
        monitor.cancel()
    }
    
    private func setupNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if path.status == .satisfied {
                    self.showHomePage()
                } else {
                    self.showNetworkErrorPage()
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    private func showHomePage() {
        let homePageVC = HomePageViewController()
        switchToViewController(homePageVC)
    }
    
    private func showNetworkErrorPage() {
        let networkErrorVC = HomePageNetworkErrorViewController {
            self.monitor.start(queue: self.queue)
        }
        switchToViewController(networkErrorVC)
    }
    
    private func switchToViewController(_ viewController: UIViewController) {
        if let currentChild = currentChild {
            currentChild.willMove(toParent: nil)
            currentChild.view.removeFromSuperview()
            currentChild.removeFromParent()
        }
        
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
        currentChild = viewController
    }
}
