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
Terms & Conditions (წესები და პირობები):

1. მომსახურების გამოყენების წესები:
- მომხმარებელი ვალდებულია აპლიკაცია გამოიყენოს კანონიერად და წესიერად.
- აკრძალულია ყალბი მონაცემების შეყვანა ან ივენთების არასწორი ინფორმაციის გავრცელება.

2. ბუქინგის პირობები:
- ყველა ბუქინგი საბოლოოა, და დაბრუნება შესაძლებელია მხოლოდ ორგანიზატორის წესების მიხედვით.
- QR კოდი არის უნიკალური და მისი გაზიარება აკრძალულია.

3. ივენთების ორგანიზატორებთან ურთიერთობა:
- აპლიკაცია მხოლოდ პლატფორმაა, და ის არ იღებს პასუხისმგებლობას ორგანიზატორების შეცდომებზე.

4. პასუხისმგებლობის შეზღუდვა:
- აპლიკაცია არ იღებს პასუხისმგებლობას:
  • ივენთის გაუქმებაზე ან დაგვიანებაზე.
  • მონაცემთა დაკარგვაზე, რომელიც გამოწვეულია მომხმარებლის დაუდევრობით.

5. ანგარიში და წვდომა:
- მომხმარებელი ვალდებულია დაიცვას თავისი ანგარიშის უსაფრთხოება.
- აპლიკაცია იტოვებს უფლებას, დაბლოკოს მომხმარებლის ანგარიში წესების დარღვევის შემთხვევაში.

6. აპლიკაციის ვერსია:
- აპლიკაცია ხელმისაწვდომია მხოლოდ iOS 16+ მოწყობილობებზე.

7. პოლიტიკის ცვლილება:
- აპლიკაციას უფლება აქვს შეცვალოს წესები ან პოლიტიკა. ცვლილებები ძალაში შევა მათი გამოქვეყნების შემდეგ.
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
