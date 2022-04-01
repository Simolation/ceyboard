//
//  DemtextKeyboardActionHandler.swift
//  keyboard
//
//  Created by Simon Osterlehner on 11.11.21.
//

import KeyboardKit
import UIKit
import CoreData

class DemtextKeyboardActionHandler: StandardKeyboardActionHandler {
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
    
    // MARK: - Overrides
    
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
                self.sessionTracker.trackEvent(action: "character", value: string)
            case .emoji(let emoji):
                self.sessionTracker.trackEvent(action: "emoji", value: emoji.char)
            case .space:
                self.sessionTracker.trackEvent(action: "character", value: " ")
            case .primary(_):
                self.sessionTracker.writeCompleteText()
                self.sessionTracker.handleSession()
            case .return:
                self.sessionTracker.trackEvent(action: "return", value: nil)
                self.sessionTracker.addReturn()
            case .backspace:
                self.sessionTracker.trackEvent(action: "backspace", value: nil)
                self.sessionTracker.addBackspace()
            case .dismissKeyboard:
                self.sessionTracker.writeCompleteText()
                self.sessionTracker.handleSession()
            default:
                print("Other action")
            }
            // Get full text
            // self.sessionTracker.writeCompleteText()
        }
    
        
        // Perform default action
        return super.handle(gesture, on: action)
    }
    
    override func tryApplyAutocompleteSuggestion(before gesture: KeyboardGesture, on action: KeyboardAction) {
        guard gesture == .tap else { return }
        guard action.shouldApplyAutocompleteSuggestion else { return }
        guard let suggestion = (autocompleteContext.suggestions.first { $0.isAutocomplete }) else { return }
        
        // Track autocorrection
        let currentWord = textDocumentProxy.currentWord
        self.sessionTracker.trackEvent(action: "autocorrect", value: suggestion.text, originalValue: currentWord)
        
        // Apply suggestion
        textDocumentProxy.insertAutocompleteSuggestion(suggestion, tryInsertSpace: false)
    }
    
    func tryReplaceSuggestions(for suggestion: AutocompleteSuggestion) {
        // Track autocomplete suggestion
        let currentWord = textDocumentProxy.currentWord
        self.sessionTracker.trackEvent(action: "autocomplete", value: suggestion.text, originalValue: currentWord)
        
        textDocumentProxy.insertAutocompleteSuggestion(suggestion)
    }
}
