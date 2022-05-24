//
//  CeyboardAutocompleteProvider.swift
//  keyboard
//
//  Created by Simon Osterlehner on 11.11.21.
//  Inspired by https://github.com/KeyboardKit/KeyboardKit/blob/master/Demo/Keyboard/Autocomplete/FakeAutocompleteProvider.swift
//

import UIKit
import Foundation
import KeyboardKit

class CeyboardAutocompleteProvider: AutocompleteProvider {
    var locale: Locale = .current
    // Provide required overwrites
    var canIgnoreWords: Bool { false }
    var canLearnWords: Bool { false }
    var ignoredWords: [String] = []
    var learnedWords: [String] = []
    
    func hasIgnoredWord(_ word: String) -> Bool { false }
    func hasLearnedWord(_ word: String) -> Bool { false }
    func ignoreWord(_ word: String) {}
    func learnWord(_ word: String) {}
    func removeIgnoredWord(_ word: String) {}
    func unlearnWord(_ word: String) {}
    
    /**
     Generate autocomplete suggestions for the currently typed text
     */
    func autocompleteSuggestions(for text: String, completion: @escaping AutocompleteCompletion) {
        // When there is no text do not generate suggestions
        guard text.count > 0 else { return completion(.success([])) }
        
        // Run autocorrect suggestions in a background thread
        DispatchQueue.background(background: {
            return CeyboardAutocompleteProvider.suggestions(for: text, languageCode: self.locale.languageCode ?? "de_DE")
        }, completion: { suggestions in
            
            // Return the suggestions
            completion(.success(suggestions))
        })
    }
}

private extension CeyboardAutocompleteProvider {
    
    /**
     Generate suggestions
     */
    static func suggestions(for text: String, languageCode: String) -> [AutocompleteSuggestion] {
        // Load user defaults to determine whether autocorrection is enabled or not
        let userDefaults = UserDefaults(suiteName: SuiteName.name)!
        let useAutocorrect = userDefaults.bool(forKey: "useAutocorrect")
        
        var result: [AutocompleteSuggestion] = []
        
        // Generate guesses for text corrections
        let guesses = self.spellCheck(for: text, autoApply: useAutocorrect, languageCode: languageCode)
        
        // The first result should always be the actual typed text as otherwise it is impossible to type unknown words
        if !guesses.isEmpty && useAutocorrect {
            result.append(suggestion(text,title: "\"\(text)\""))
        }
        
        for guess in guesses {
            result.append(guess)
        }
        
        // Only show a maximum of 3 results
        if result.count < 3 {
            // Only add suggestions when the guesses are less than three
            let checker = UITextChecker()
            let possible_completions = checker.completions(forPartialWordRange: NSRange(location: 0, length: text.count), in: text, language: languageCode) ?? []
            
            // Only take the missing number of suggestions
            let shown_completions = possible_completions.prefix(3 - result.count)
            
            for suggested_word in shown_completions {
                result.append(suggestion(suggested_word))
            }
        }
        
        return result
    }
    
    /**
     Perform spellcheck checker and generate suggestions
     */
    static func spellCheck(for text: String, autoApply: Bool = false, languageCode: String) -> [AutocompleteSuggestion] {
        let checker = UITextChecker()
        
        let range = NSMakeRange(0, text.count)
        
        // Create range with misspelled words
        let misspelledRange: NSRange = checker.rangeOfMisspelledWord(in: text, range: range, startingAt: range.location, wrap: true, language: languageCode)
        
        var result: [AutocompleteSuggestion] = []
        
        if misspelledRange.location != NSNotFound {
            // Get guesses for corrected words
            let guesses = checker.guesses(forWordRange: misspelledRange, in: text, language: languageCode)
            
            let shown_guesses = guesses?.prefix(3) ?? []
            
            var counter = 0
            
            // Add guesses to result array
            for guessed_word in shown_guesses {
                // Disabled autocomplete change due to aggressive replacement
                result.append(suggestion(guessed_word, isAutocomplete: autoApply && counter == 0))
                counter += 1
            }
        }
        
        return result
    }
    
    /**
     Helper function to build AutocompleteSuggestion items
     */
    static func suggestion(_ word: String, _ subtitle: String? = nil, isAutocomplete: Bool = false, title: String? = nil) -> AutocompleteSuggestion {
        StandardAutocompleteSuggestion(text: word, title: title ?? word, isAutocomplete: isAutocomplete, isUnknown: false, subtitle: subtitle)
    }
}
