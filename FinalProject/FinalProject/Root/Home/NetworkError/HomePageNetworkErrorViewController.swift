//
//  HomePageNetworkErrorViewController.swift
//  FinalProject
//
//  Created by Apple on 26.01.25.
//

import UIKit

final class HomePageNetworkErrorViewController: UIViewController {
    
    private let retryAction: () -> Void
    
    private let messageLabel = UILabel()
    private let detailLabel = UILabel()
    private let retryButton = UIButton(type: .system)
    
    init(retryAction: @escaping () -> Void) {
        self.retryAction = retryAction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addRetryButtonAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        messageLabel.text = "Unable to connect to the internet".localized()
        detailLabel.text = "Please check your internet connection and try again.".localized()
        retryButton.setTitle("Retry".localized(), for: .normal)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        let icon = UIImageView(image: UIImage(systemName: "wifi.slash"))
        icon.tintColor = .systemRed
        icon.contentMode = .scaleAspectFit
        
        messageLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        messageLabel.textAlignment = .center
        
        detailLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        detailLabel.textColor = .secondaryLabel
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 0
        
        retryButton.setTitleColor(.white, for: .normal)
        retryButton.backgroundColor = .systemBlue
        retryButton.layer.cornerRadius = 8
        retryButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        retryButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [icon, messageLabel, detailLabel, retryButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func addRetryButtonAction() {
        retryButton.addAction(UIAction { [weak self] _ in
            self?.retryAction()
        }, for: .touchUpInside)
    }
}
