//
//  SessionDto.swift
//  demtext
//
//  Created by Simon Osterlehner on 18.12.21.
//

import Foundation

public class SessionDto {
    var started_at: Date = Date()
    var ended_at: Date?
    var hostApp: String?
    var events: [SessionEventDto] = []
    var fullText: String?

    
    init(hostApp: String?) {
        self.hostApp = hostApp
    }
    
    func length() -> Int {
        self.events.count
    }
}

extension Session: Encodable {
    private enum CodingKeys: String, CodingKey { case started_at, ended_at, hostApp, events, fullText, words, sentences, avg_text_length, localRepetitions, intraSessionRepetitions }

    public static var includeTextUserInfoKey: CodingUserInfoKey {
        return CodingUserInfoKey(rawValue: "includeText")!
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(started_at, forKey: .started_at)
        try container.encodeIfPresent(ended_at, forKey: .ended_at)
        try container.encodeIfPresent(hostApp, forKey: .hostApp)
        
        // Only include text if user info allows it
        if encoder.userInfo[Self.includeTextUserInfoKey] as! Bool == true {
            try container.encodeIfPresent(fullText, forKey: .fullText)
        }
        
        // Encode events array
        let eventsArray = events?.allObjects as! [SessionEvent]
        try container.encodeIfPresent(eventsArray, forKey: .events)
    }
}
