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
Privacy Policy (კონფიდენციალურობის პოლიტიკა):

1. რა მონაცემებს აგროვებთ:
- პერსონალური ინფორმაცია: მომხმარებლის სახელი, ელფოსტა, პაროლი, ტელეფონის ნომერი.
- ბუქინგის მონაცემები: დაჯავშნილი ივენთები და შესაბამისი უნიკალური QR კოდები.
- ტექნიკური ინფორმაცია: მოწყობილობის ტიპი, iOS-ის ვერსია, აპლიკაციის გამოყენების სტატისტიკა.
- ლოკაციის მონაცემები (თუ იყენებთ): ფილტრაციისთვის ან ივენთების შეთავაზებისთვის.

2. მონაცემების გამოყენება:
- ანგარიშის შექმნა და იდენტიფიკაცია.
- ივენთების ბუქინგი და QR კოდების გენერაცია.
- ფილტრაციის შედეგების დახვეწა და მომხმარებლისთვის შესაბამისი შეთავაზებების გაკეთება.
- აპლიკაციის ფუნქციონირების გაუმჯობესება და შეცდომების გამოსწორება.

3. მონაცემების გაზიარება:
- მონაცემები არ გადაეცემა მესამე მხარეებს, გარდა:
  • ივენთების ორგანიზატორებისა (დაჯავშნულ ივენთებზე დასწრების უზრუნველყოფისთვის).
  • Firebase-ის (მონაცემთა ბაზის და ავტენტიფიკაციის მართვისთვის).
  • Google Analytics ან Crashlytics (თუ იყენებთ) ანალიზისთვის.

4. უსაფრთხოება:
- მონაცემები ინახება Firebase-ში დეფოლტად დაშიფრული ფორმით.
- კომუნიკაცია მიმდინარეობს SSL პროტოკოლით.

5. მომხმარებლის უფლებები:
- მონაცემებზე წვდომის, რედაქტირების ან წაშლის მოთხოვნა.
- ანგარიშის წაშლის შესაძლებლობა.

6. კონტაქტი:
- თუ გაქვთ კითხვები, შეგიძლიათ მოგვმართოთ ელფოსტაზე: gvaramia.andria@tbcacademy.edu.ge
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
