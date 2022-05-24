//
//  UserDefaults.swift
//  ceyboard
//
//  Created by Simon Osterlehner on 14.02.22.
//

import Foundation

/**
 Extend the UserDefault to support Date as data
 */
extension Date: RawRepresentable {
    private static let formatter = ISO8601DateFormatter()
    
    public var rawValue: String {
        Date.formatter.string(from: self)
    }
    
    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
}

extension UserDefaults {
    func set(date: Date?, forKey key: String){
        self.set(date?.rawValue, forKey: key)
    }
    
    func date(forKey key: String) -> Date? {
        if let raw = self.value(forKey: key) {
            return Date.init(rawValue: raw as! String)
        } else {
            return nil
        }
    }
}
