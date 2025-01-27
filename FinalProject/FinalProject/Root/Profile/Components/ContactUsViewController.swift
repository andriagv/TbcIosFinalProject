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
        return createLabel(
            text: "Contact Us",
            font: UIFont.boldSystemFont(ofSize: 24),
            textAlignment: .center
        )
    }()
    
    private let subtitleLabel: UILabel = {
        return createLabel(
            text: "Feel free to reach out through email or social links.",
            font: UIFont.systemFont(ofSize: 14),
            textColor: .gray,
            textAlignment: .center
        )
    }()
    
    private lazy var emailButton: UIButton = {
        return createButton(
            title: "gvaramia.andria@tbcacademy.edu.ge"
        ) { [weak self] in
            self?.openEmail()
        }
    }()
    
    private lazy var linkedInButton: UIButton = {
        return createButton(
            title: "LinkedIn Profile"
        ) { [weak self] in
            self?.openURL("https://www.linkedin.com/in/andria-gvaramia-b85935229/")
        }
    }()
    
    private lazy var facebookButton: UIButton = {
        return createButton(
            title: "Facebook Profile"
        ) { [weak self] in
            self?.openURL("https://www.facebook.com/andria361791/")
        }
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
    
    // MARK: - Helper Functions
    
    private static func createLabel(
        text: String,
        font: UIFont = UIFont.systemFont(ofSize: 14),
        textColor: UIColor = .label,
        textAlignment: NSTextAlignment = .left
    ) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment
        return label
    }
    
    private func createButton(
        title: String,
        font: UIFont = UIFont.systemFont(ofSize: 16),
        titleColor: UIColor = .label,
        action: @escaping () -> Void
    ) -> UIButton {
        let button = UIButton(type: .system)
        
        var config = UIButton.Configuration.plain()
        config.title = title
        config.baseForegroundColor = titleColor
        
        var attributedTitle = AttributedString(title)
        attributedTitle.font = font
        config.attributedTitle = attributedTitle
        
        button.configuration = config
        button.contentHorizontalAlignment = .leading
        button.addAction(UIAction(handler: { _ in action() }), for: .touchUpInside)
        return button
    }
    
    // MARK: - Actions
    
    private func openEmail() {
        let email = "gvaramia.andria@tbcacademy.edu.ge"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
