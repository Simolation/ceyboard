//
//  KeyboardHiddenInput.swift
//  ceyboard
//
//  Created by Simon Osterlehner on 26.02.22.
//  Source: https://stackoverflow.com/a/57040128
//

import UIKit
import SwiftUI

class UIOpenKeyboard: UIView {
    override var canBecomeFirstResponder: Bool { return true }
    override var canResignFirstResponder: Bool { return true }
}

// MARK: - UIKeyInput
// Modify if need more functionality
extension UIOpenKeyboard: UIKeyInput {
    var hasText: Bool { return false }
    func insertText(_ text: String) {}
    func deleteBackward() {}
}

/// Open the keyboard without text field or similar view
struct OpenKeyboard: UIViewRepresentable {
    func makeUIView(context: Context) -> UIOpenKeyboard {
        
        let keyInputView = UIOpenKeyboard()
        keyInputView.becomeFirstResponder()
        
        return keyInputView
    }
    
    func updateUIView(_ uiView: UIOpenKeyboard, context: Context) {}
}
