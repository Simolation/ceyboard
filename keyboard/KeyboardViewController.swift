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
        
        // Uncomment this line to customize when to use dark
        // appearance colors.
        // Color.darkAppearanceStrategy = { _ in false }
        
        // Use demtext autocomplete
        autocompleteProvider = CustomAutocompleteProvider()
        
        // Setup a demo-specific apearance
        // 💡 You can play around with the DemoAppearance
        // keyboardAppearance = DemoAppearance(context: keyboardContext)
        
        // Use german locale
        keyboardContext.locale = KeyboardLocale.german.locale
        
        // Use german locale
        keyboardContext.locales = [KeyboardLocale.german.locale]
        
        // demtext action handler
        keyboardActionHandler = DemtextKeyboardActionHandler(
            inputViewController: self)
        
        // Use German keyboard layout
        inputSetProvider = StandardInputSetProvider(
            context: keyboardContext,
            providers: [GermanKeyboardInputSetProvider()])
        
        // Use standard keyboard layout with emojis
        keyboardLayoutProvider = StandardKeyboardLayoutProvider(
            inputSetProvider: inputSetProvider,
            dictationReplacement: .keyboardType(.emojis))
        
        // Setup a secondary callout action provider
        // 💡 This is already done and just here to show how
        // 💡 This is overwritten if Pro is registered below
        /* keyboardSecondaryCalloutActionProvider = StandardSecondaryCalloutActionProvider(
         context: keyboardContext,
         providers: [try? EnglishSecondaryCalloutActionProvider()].compactMap { $0 }) */
        
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
     Override this function to add custom autocomplete logic
     to your keyboard extension.
     */
    override func performAutocomplete() {
        super.performAutocomplete()
    }
    
    /**
     Override this function to add custom autocomplete reset
     logic to your keyboard extension.
     */
    override func resetAutocomplete() {
        super.resetAutocomplete()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // Get the full text of the field before the input chaged
        SessionTracker.shared.writeCompleteText()
        
        super.textWillChange(textInput)
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // Check if the input has been cleared and store the session
        SessionTracker.shared.handleSessionIfTextFieldIsEmpty()
        
        super.textDidChange(textInput)
    }
}
