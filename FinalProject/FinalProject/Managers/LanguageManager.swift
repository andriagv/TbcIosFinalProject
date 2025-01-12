//
//  LanguageManager.swift
//  FinalProject
//
//  Created by Apple on 12.01.25.
//

import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()

    @Published var selectedLanguage: String = "en" {
        didSet {
            updateLanguage(to: selectedLanguage)
        }
    }
    
    init() {
        if let savedLanguage = UserDefaults.standard.stringArray(forKey: "AppleLanguages")?.first {
            selectedLanguage = savedLanguage
            updateLanguage(to: savedLanguage)
        }
    }

    func setLanguage(_ language: String) {
        selectedLanguage = language
        updateLanguage(to: language)
    }

    private func updateLanguage(to language: String) {
        UserDefaults.standard.set([language], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        Bundle.setLanguage(language)
    }

    var supportedLanguages: [String] {
        return ["en", "ka"]
    }

    func languageDisplayName(for languageCode: String) -> String {
        switch languageCode {
        case "en": return "English"
        case "ka": return "Georgian"
        default: return ""
        }
    }
}

extension Bundle {
    private static var bundleKey: UInt8 = 0

    static func setLanguage(_ language: String) {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let languageBundle = Bundle(path: path) else {
            print("Localization file not found for language: \(language)")
            return
        }
        objc_setAssociatedObject(Bundle.main, &bundleKey, languageBundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    static func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let bundle = objc_getAssociatedObject(Bundle.main, &bundleKey) as? Bundle else {
            return Bundle.main.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension String {
    func localized() -> String {
        return Bundle.localizedString(forKey: self, value: nil, table: nil)
    }
}
