//
//  ContactUsViewController.swift
//  FinalProject
//
//  Created by Apple on 19.01.25.
//

import UIKit

class ContactUsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Contact Us"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Feel free to reach out through email or social links."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emailButton: UIButton = {
        return createRowButton(
            iconName: "ic_email",
            title: "gvaramia.andria@tbcacademy.edu.ge",
            action: #selector(emailTapped)
        )
    }()
    
    private lazy var linkedInButton: UIButton = {
        return createRowButton(
            iconName: "ic_linkedin",
            title: "LinkedIn Profile",
            action: #selector(linkedInTapped)
        )
    }()
    
    private lazy var facebookButton: UIButton = {
        return createRowButton(
            iconName: "ic_facebook",
            title: "Facebook Profile",
            action: #selector(facebookTapped)
        )
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        if let sheet = sheetPresentationController {
            sheet.detents = [
                .custom { context in
                    return 0.7 * context.maximumDetentValue
                }
            ]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        let headerStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        headerStack.axis = .vertical
        headerStack.alignment = .center
        headerStack.spacing = 4
        
        let mainStack = UIStackView(arrangedSubviews: [headerStack, emailButton, linkedInButton, facebookButton])
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.spacing = 20
        
        view.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    // MARK: - Helper to create row (button with icon + text)
    private func createRowButton(iconName: String, title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: iconName)
        config.imagePadding = 8
        config.imagePlacement = .leading
        config.title = title
        config.baseForegroundColor = .label
        
        // Bigger font
        var titleAttr = AttributedString(title)
        titleAttr.font = .systemFont(ofSize: 16)
        config.attributedTitle = titleAttr
        
        button.configuration = config
        
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    // MARK: - Actions
    @objc private func emailTapped() {
        let email = "gvaramia.andria@tbcacademy.edu.ge"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func linkedInTapped() {
        let urlString = "https://www.linkedin.com/in/andria-gvaramia-b85935229/"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func facebookTapped() {
        let urlString = "https://www.facebook.com/andria361791/"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
