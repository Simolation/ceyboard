//
//  GermanKeyboardInputSetProvider.swift.swift
//  keyboard
//
//  Created by Simon Osterlehner on 11.11.21.
//

import UIKit
import KeyboardKit
import Foundation


class GermanKeyboardInputSetProvider: DeviceSpecificInputSetProvider, LocalizedService {
    public init(device: UIDevice = .current) {
        self.device = device
    }
    
    /**
     The device for which the input should apply.
     */
    public let device: UIDevice
    
    /**
     The locale identifier.
     */
    public let localeKey: String = KeyboardLocale.german.id
    
    /**
     The input set to use for alphabetic keyboards.
     */
    public var alphabeticInputSet: AlphabeticInputSet {
        // Load umlaute settings
        let userDefaults = UserDefaults(suiteName: SuiteName.name)!
        let useUmlaute = userDefaults.bool(forKey: "useUmlaute")
        
        if useUmlaute {
            return AlphabeticInputSet(rows: [
                row("qwertzuiopü"),
                row("asdfghjklöä"),
                row(phone: "yxcvbnm", pad: "yxcvbnm,.")
            ])
            
        } else {
            return AlphabeticInputSet(rows: [
                row("qwertzuiop"),
                row("asdfghjkl"),
                row(phone: "yxcvbnm", pad: "yxcvbnm,.")
            ])
        }
    }
    
    /**
     The input set to use for numeric keyboards.
     */
    public var numericInputSet: NumericInputSet {
        NumericInputSet(rows: [
            row("1234567890"),
            row(phone: "-/:;()€&@”", pad: "@#€&*()’”"),
            row(phone: ".,?!’", pad: "%-+=/;:,.")
        ])
    }
    
    /**
     The input set to use for symbolic keyboards.
     */
    public var symbolicInputSet: SymbolicInputSet {
        SymbolicInputSet(rows: [
            row(phone: "[]{}#%^*+=", pad: "1234567890"),
            row(phone: "_\\|~<>$£¥•", pad: "$£_^[]{}"),
            row(phone: ".,?!’", pad: "§|~…\\<>!?")
        ])
    }
}
