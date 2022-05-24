//
//  CeyboardKeyboardActionHandler.swift
//  keyboard
//
//  Created by Simon Osterlehner on 11.11.21.
//

import KeyboardKit
import UIKit
import CoreData

class CeyboardKeyboardActionHandler: StandardKeyboardActionHandler {
    private var viewContext: NSManagedObjectContext
    private let sessionTracker: SessionTracker
    
    public init(inputViewController: KeyboardInputViewController) {
        // Initialize persistence controller
        let controller = PersistenceController.shared
        self.viewContext = controller.container.viewContext
        self.sessionTracker = SessionTracker.shared
        super.init(inputViewController: inputViewController)
        self.sessionTracker.bindProxy(keyboardContext: keyboardContext)
    }
    
    // MARK: - Handle actions
    
    override func handle(_ gesture: KeyboardGesture, on action: KeyboardAction) {
        // Collect .longPress gesture events
        if gesture == .longPress {
            switch action {
            case .backspace:
                self.sessionTracker.handleLongPressBackspace()
            default:
                print("Other long press")
            }
        }
        
        // Collect .tap gesture events
        if gesture == .tap {
            switch action {
            case .character(let string):
                // A regular character has been typed
                self.sessionTracker.trackEvent(action: "character", value: string)
            case .emoji(let emoji):
                // An emoji has been used
                self.sessionTracker.trackEvent(action: "emoji", value: emoji.char)
            case .space:
                // Space character
                self.sessionTracker.trackEvent(action: "character", value: " ")
            case .primary(_):
                // Submit, Send, etc.
                self.sessionTracker.writeCompleteText()
                self.sessionTracker.handleSession()
            case .return:
                // Return key
                self.sessionTracker.trackEvent(action: "return", value: nil)
                self.sessionTracker.addReturn()
            case .backspace:
                // Backspace key
                self.sessionTracker.trackEvent(action: "backspace", value: nil)
                self.sessionTracker.addBackspace()
            case .dismissKeyboard:
                // Keyboard has been closed
                self.sessionTracker.writeCompleteText()
                self.sessionTracker.handleSession()
            default:
                print("Unknown other action")
            }
        }
        
        
        // Perform default action
        return super.handle(gesture, on: action)
    }
    
    // MARK: Handle autocomplete
    
    /**
     Intercept the autocorrect insertion to track the event in the session tracker
     */
    override func tryApplyAutocompleteSuggestion(before gesture: KeyboardGesture, on action: KeyboardAction) {
        // Resolve the suggestion
        guard gesture == .tap else { return }
        guard action.shouldApplyAutocompleteSuggestion else { return }
        guard let suggestion = (autocompleteContext.suggestions.first { $0.isAutocomplete }) else { return }
        
        // Track autocorrection
        let currentWord = textDocumentProxy.currentWord
        self.sessionTracker.trackEvent(action: "autocorrect", value: suggestion.text, originalValue: currentWord)
        
        // Apply suggestion
        textDocumentProxy.insertAutocompleteSuggestion(suggestion, tryInsertSpace: false)
    }
    
    /**
     Intercept the autocomplete insertion to track the event in the session tracker
     */
    func tryReplaceSuggestions(for suggestion: AutocompleteSuggestion) {
        // Track autocomplete suggestion
        let currentWord = textDocumentProxy.currentWord
        self.sessionTracker.trackEvent(action: "autocomplete", value: suggestion.text, originalValue: currentWord)
        
        // Apply suggestion
        textDocumentProxy.insertAutocompleteSuggestion(suggestion)
    }
}
