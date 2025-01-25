//
//  PrivacyPolicyViewController.swift
//  FinalProject
//
//  Created by Apple on 19.01.25.
//

import UIKit

// MARK: - PrivacyPolicyViewController
class PrivacyPolicyViewController: UIViewController {
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.isSelectable = true
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.text = """
კონფიდენციალურობის პოლიტიკა

1. შეგროვებული მონაცემები
• პერსონალური: სახელი, ელფოსტა, პაროლი, ტელეფონი
• ბუქინგები: დაჯავშნილი ივენთები, QR კოდები
• ტექნიკური: მოწყობილობა, iOS ვერსია
• ლოკაცია: ივენთების ფილტრაციისთვის

2. მონაცემების გამოყენება
• ანგარიშის მართვა
• ბუქინგების დაჯავშნა
• ფილტრაცია და შეთავაზებები
• აპლიკაციის გაუმჯობესება

3. გაზიარება
მონაცემებს ვუზიარებთ მხოლოდ:
• ივენთების ორგანიზატორებს
• Firebase-ს
• Google Analytics-ს

4. უსაფრთხოება
• დაშიფრული შენახვა Firebase-ში
• SSL კომუნიკაცია

5. თქვენი უფლებები
• მონაცემების ნახვა და რედაქტირება
• ანგარიშის წაშლა

6. კონტაქტი
gvaramia.andria@tbcacademy.edu.ge
"""
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
