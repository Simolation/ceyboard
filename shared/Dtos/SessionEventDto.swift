//
//  EventDto.swift
//  ceyboard
//
//  Created by Simon Osterlehner on 18.12.21.
//

import Foundation

public class SessionEventDto {
    var created_at: Date = Date()
    var action: String
    var value: String?
    var originalValue: String?
    
    init(action: String, value: String?, originalValue: String?) {
        self.action = action
        self.value = value
        self.originalValue = originalValue
    }
    
    func length() -> Int {
        self.value?.count ?? 1
    }
}

extension SessionEvent: Encodable {
    private enum CodingKeys: String, CodingKey { case created_at, action, value, originalValue }
    
    /**
     Handle the encoding for the event export
     Automatically purge the value and originalValue fields
     */
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(created_at, forKey: .created_at)
        try container.encode(action, forKey: .action)
        
        // Only include text value if user info allows it
        if encoder.userInfo[Session.includeTextUserInfoKey] as! Bool == true {
            try container.encodeIfPresent(value, forKey: .value)
            try container.encodeIfPresent(originalValue, forKey: .originalValue)
        }
    }
}
