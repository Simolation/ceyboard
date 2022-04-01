//
//  SessionTracker.swift
//  demtext
//
//  Created by Constantin Ehmanns on 29.11.21.
//

import Foundation
import CoreData
import SwiftUI
import KeyboardKit

// keep track of one writing session (i.e. until the user hits send/return/...)
class SessionTracker {
    public static let shared = SessionTracker()
    
    private var viewContext: NSManagedObjectContext
    private var keyboardContext: KeyboardContext?
    
    public static var hostBundle: String?
    
    var currentSession: SessionDto?
    
    var hasStarted = false
    
    var completeTextBeforeReturn: [String] = []
    var completeText = ""
    
    var charCounter = 0
    var hasMovedCursorSignificantly = false
    var backspaceLongPressed = false
    
    var timer = Timer()
    // intialize in actionHandler after PersitenceController
    public init() {
        self.viewContext = PersistenceController.shared.container.viewContext
        
        // Start new session
        self.handleSession()
    }
    
    
    func bindProxy(keyboardContext: KeyboardContext) {
        self.keyboardContext = keyboardContext
    }
    
    func handleSessionIfTextFieldIsEmpty() {
        if (self.hasStarted && (self.textFieldIsEmpty())){
            self.handleSession()
        }
    }
    
    public func handleSession() {
        // If there is a session with events store the items
        if (self.currentSession?.events.count ?? 0) > 0 {
            // add current paragraph
            addReturn()
            // print("Full Document: \(self.completeTextBeforeReturn.joined(separator: "\n"))")
            
            // Finalize current session
            self.currentSession?.ended_at = Date()
            self.currentSession?.fullText = self.completeTextBeforeReturn.joined(separator: "\n")
            writeToDb()
            
            // clean-up
            self.currentSession = nil
            self.hasStarted = false
            self.completeText = ""
            self.completeTextBeforeReturn = []
            self.charCounter = 0
            self.hasMovedCursorSignificantly = false
            self.backspaceLongPressed = false
        }
        
        // Create a new session instance
        self.currentSession = SessionDto(hostApp: SessionTracker.hostBundle)
    }
    
    func textFieldIsEmpty() -> Bool {
        let textBefore = self.keyboardContext?.textDocumentProxy.documentContextBeforeInput
        let textAfter = self.keyboardContext?.textDocumentProxy.documentContextAfterInput
        // overwriting with empty string after has been cleared
        
        // self.writeCompleteText()
        
        return (textBefore == "" && textAfter == "") || self.textFieldGone()
    }
    
    func textFieldGone() -> Bool {
        ((self.keyboardContext?.textDocumentProxy.documentContextBeforeInput == nil) && (self.keyboardContext?.textDocumentProxy.documentContextAfterInput == nil))
    }
    
    func writeCompleteText() {
        let textBefore = self.keyboardContext?.textDocumentProxy.documentContextBeforeInput
        let textAfter = self.keyboardContext?.textDocumentProxy.documentContextAfterInput
        
        if (textBefore != nil || textAfter != nil) && !self.hasMovedCursorSignificantly {
            let text = (textBefore ?? "") + (textAfter ?? "")
            if text.count + 1 >= self.charCounter {
                self.completeText = text
            } else if !self.backspaceLongPressed {
                // print("Recording stopped. Text is: \(text) and charCounter is: \(self.charCounter)")
                self.hasMovedCursorSignificantly = true
            }
        }
    }
    
    func computeTextLength() -> Int {
        let textBefore = self.keyboardContext?.textDocumentProxy.documentContextBeforeInput
        let textAfter = self.keyboardContext?.textDocumentProxy.documentContextAfterInput
        
        if textBefore != nil || textAfter != nil {
            let text = (textBefore ?? "") + (textAfter ?? "")
            return text.count
        } else {
            return 0
        }
    }
    
    func trackEvent(action: String, value: String?, originalValue: String? = nil) {
        // the user has definitely started doing something
        self.hasStarted = true
        
        // Update complete text
        writeCompleteText()
        
        // count characters
        if action == "character" || action == "emoji" {
            self.charCounter += 1
            if self.backspaceLongPressed {
                self.backspaceLongPressed = false
                self.charCounter = self.computeTextLength() + 1
            }
        }
        
        // Create new event
        let sessionEvent = SessionEventDto(action: action, value: value, originalValue: originalValue)
        
        // Add event to current session
        self.currentSession?.events.append(sessionEvent)
    }
    
    func addReturn() {
        // print("Added: \(self.completeText)")
        self.completeTextBeforeReturn.append(self.completeText)
        self.completeText = ""
        self.charCounter = 0
        self.hasMovedCursorSignificantly = false
    }
    
    func addBackspace() {
        if self.charCounter > 0 {
            self.charCounter -= 1
        }
    }
    
    func handleLongPressBackspace() {
        // print("Long press detected")
        self.backspaceLongPressed = true
    }
    
    func writeToDb() {
        // loop through property DTOs and store in viewContext
        guard let currentSession = self.currentSession else {
            return
        }
        
        if currentSession.events.isEmpty {
            // Don't store when there are no events
            return
        }
        
        // Build core data elements
        let session = Session(context: self.viewContext)
        
        session.started_at = currentSession.started_at
        session.ended_at = currentSession.ended_at
        session.hostApp = currentSession.hostApp
        session.fullText = currentSession.fullText
        
        for sessionEvent in currentSession.events {
            // Create all session events
            let event = SessionEvent(context: self.viewContext)
            event.created_at = sessionEvent.created_at
            event.action = sessionEvent.action
            event.value = sessionEvent.value
            event.originalValue = sessionEvent.originalValue
            
            session.addToEvents(event)
        }
        
        // Store data to database
        do {
            // Save context
            try self.viewContext.save()
        } catch {
            print("ST: Error while writing viewContext")
        }
    }
}
