//
//  TermsAndConditionsViewController.swift
//  FinalProject
//
//  Created by Apple on 19.01.25.
//

import UIKit

// MARK: - TermsAndConditionsViewController
class TermsAndConditionsViewController: UIViewController {
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.isSelectable = true
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.text = """
        წესები და პირობები
        
        1. მომსახურების გამოყენება
        მომხმარებელი ვალდებულია აპლიკაცია გამოიყენოს კანონიერად და წესიერად.
        აკრძალულია ყალბი მონაცემების შეყვანა ან ივენთების არასწორი ინფორმაციის გავრცელება.
        
        2. ბუქინგის წესები
        ყველა ბუქინგი საბოლოოა, და დაბრუნება შესაძლებელია მხოლოდ ორგანიზატორის წესების მიხედვით.
        QR კოდი არის უნიკალური და მისი გაზიარება აკრძალულია.
        
        3. ორგანიზატორებთან ურთიერთობა
        აპლიკაცია მხოლოდ პლატფორმაა, და ის არ იღებს პასუხისმგებლობას ორგანიზატორების შეცდომებზე.
        
        4. პასუხისმგებლობის შეზღუდვა
        აპლიკაცია არ იღებს პასუხისმგებლობას:
        • ივენთის გაუქმებაზე ან დაგვიანებაზე
        • მონაცემთა დაკარგვაზე
        
        5. ანგარიშის უსაფრთხოება
        მომხმარებელი ვალდებულია დაიცვას ანგარიშის უსაფრთხოება.
        აპლიკაცია იტოვებს უფლებას დაბლოკოს ანგარიში წესების დარღვევისას.
        
        6. სისტემური მოთხოვნები
        აპლიკაცია ხელმისაწვდომია iOS 16+ მოწყობილობებზე.
        
        7. ცვლილებები
        აპლიკაციას უფლება აქვს შეცვალოს წესები. ცვლილებები ძალაში შევა გამოქვეყნებისთანავე.
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
