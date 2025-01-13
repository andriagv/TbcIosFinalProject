//
//  StringExtension.swift
//  FinalProject
//
//  Created by Apple on 13.01.25.
//

import SwiftUI

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

