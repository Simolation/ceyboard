//
//  KeyboardViewController.swift
//  keyboard
//
//  Created by Simon Osterlehner on 11.11.21.
//  Inspired by https://github.com/KeyboardKit/KeyboardKit/blob/master/Demo/Keyboard/KeyboardViewController.swift
//

import UIKit
import KeyboardKit
import SwiftUI
import Combine

class KeyboardViewController: KeyboardInputViewController {
    
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        
        // Use ceyboard autocomplete
        autocompleteProvider = CeyboardAutocompleteProvider()
        
        // Use german locale
        keyboardContext.locale = KeyboardLocale.german.locale
        keyboardContext.locales = [KeyboardLocale.german.locale]
        
        // ceyboard action handler
        keyboardActionHandler = CeyboardKeyboardActionHandler(
            inputViewController: self)
        
        // Use German keyboard layout
        inputSetProvider = StandardInputSetProvider(
            context: keyboardContext,
            providers: [GermanKeyboardInputSetProvider()])
        
        // Use standard keyboard layout with emojis
        keyboardLayoutProvider = StandardKeyboardLayoutProvider(
            inputSetProvider: inputSetProvider,
            dictationReplacement: .keyboardType(.emojis))
        
        // Provide the current host bundle id to the session tracker
        SessionTracker.hostBundle = activeAppBundleId
        
        // Perform the base initialization
        super.viewDidLoad()
    }
    
    override func viewWillSetupKeyboard() {
        super.viewWillSetupKeyboard()
        
        // Setup KeyboardKit
        setup(with: keyboardView)
    }
    
    
    // MARK: - Properties
    
    private var keyboardView: some View {
        KeyboardView(
            actionHandler: keyboardActionHandler,
            appearance: keyboardAppearance,
            layoutProvider: keyboardLayoutProvider)
    }
    
    
    // MARK: - Autocomplete
    
    /**
     Detect upcoming change of the text field to store the entire typed text
     */
    override func textWillChange(_ textInput: UITextInput?) {
        // Get the full text of the field before the input chaged
        SessionTracker.shared.writeCompleteText()
        
        super.textWillChange(textInput)
    }
    
    /**
     End a session when the input filed has been cleared.
     Needed for messenger like WhatsApp etc which clear the input field after sending
     */
    override func textDidChange(_ textInput: UITextInput?) {
        // Check if the input has been cleared and store the session
        SessionTracker.shared.handleSessionIfTextFieldIsEmpty()
        
        super.textDidChange(textInput)
    }
}
