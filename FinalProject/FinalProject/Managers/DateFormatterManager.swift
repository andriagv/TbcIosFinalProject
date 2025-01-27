//
//  DateFormatterManager.swift
//  FinalProject
//
//  Created by Apple on 19.01.25.
//


import Foundation

final class DateFormatterManager {
    static let shared = DateFormatterManager()
    private let dateFormatter = DateFormatter()
    
    private init() {}
    
    func formatDate(_ dateString: String, from inputFormat: String = "yyyy-MM-dd", to outputFormat: String = "MM-dd") -> String {
        dateFormatter.dateFormat = inputFormat
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = outputFormat
            return dateFormatter.string(from: date)
        }
        return dateString
    }
}
