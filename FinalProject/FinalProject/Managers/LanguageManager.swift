//
//  LanguageManager.swift
//  FinalProject
//
//  Created by Apple on 12.01.25.
//

import Foundation
import SwiftUI

protocol LanguageManaging {
    var selectedLanguage: String { get set }
    var supportedLanguages: [String] { get }
    func setLanguage(_ language: String)
    func languageDisplayName(for languageCode: String) -> String
}

final class LanguageManager: ObservableObject, LanguageManaging {
    static let shared = LanguageManager()

    @Published var selectedLanguage: String {
        didSet {
            saveLanguageToUserDefaults(selectedLanguage)
            updateLanguage(to: selectedLanguage)
        }
    }

    init() {
        let savedLanguage = UserDefaults.standard.string(forKey: "AppSelectedLanguage") ?? "en"
        self.selectedLanguage = savedLanguage
        updateLanguage(to: savedLanguage)
    }

    func setLanguage(_ language: String) {
        selectedLanguage = language
    }

    private func updateLanguage(to language: String) {
        Bundle.setLanguage(language)
    }

    private func saveLanguageToUserDefaults(_ language: String) {
        UserDefaults.standard.set(language, forKey: "AppSelectedLanguage")
        UserDefaults.standard.synchronize()
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
