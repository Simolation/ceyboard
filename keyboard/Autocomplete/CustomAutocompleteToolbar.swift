//
//  DemtextAutocompleteToolbar.swift
//  keyboard
//
//  Created by Constantin Ehmanns on 06.12.21.
//  Inspired by: https://github.com/KeyboardKit/KeyboardKit/blob/master/Sources/KeyboardKit/Views/Autocomplete/AutocompleteToolbar.swift

import SwiftUI
import KeyboardKit

public struct CustomAutocompleteToolbar: View {
    
    /**
     Create an autocomplete toolbar.
     
     - Parameters:
       - suggestions: A list of suggestions to display in the toolbar.
       - locale: The locale to apply to the toolbar.
       - style: The style to apply to the toolbar, by default `.standard`.
       - itemBuilder: An optional, custom item builder. By default, the static `standardItem` will be used.
       - separatorBuilder: An optional, custom separator builder. By default, the static `standardSeparator` will be used.
       - replacementAction: An optional, custom replacement action. By default, the static `standardReplacementAction` will be used.
     */
    public init(
        suggestions: [AutocompleteSuggestion],
        locale: Locale,
        style: AutocompleteToolbarStyle = .standard,
        itemBuilder: @escaping ItemBuilder = Self.standardItem,
        separatorBuilder: @escaping SeparatorBuilder = Self.standardSeparator,
        replacementAction: @escaping ReplacementAction = Self.standardReplacementAction) {
        self.items = suggestions.map { BarItem($0) }
        self.itemBuilder = itemBuilder
        self.locale = locale
        self.style = style
        self.separatorBuilder = separatorBuilder
        self.replacementAction = replacementAction
    }
    
    private let items: [BarItem]
    private let locale: Locale
    private let style: AutocompleteToolbarStyle
    private let itemBuilder: ItemBuilder
    private let replacementAction: ReplacementAction
    private let separatorBuilder: SeparatorBuilder
    
    /**
     This internal struct is used to encapsulate item data.
     */
    struct BarItem: Identifiable {
        
        init(_ suggestion: AutocompleteSuggestion) {
            self.suggestion = suggestion
        }
        
        public let id = UUID()
        public let suggestion: AutocompleteSuggestion
    }
    
    /**
     This typealias represents the action block that is used
     to create autocomplete suggestion views, which are then
     wrapped in buttons that trigger the `replacementAction`.
     */
    public typealias ItemBuilder = (AutocompleteSuggestion, Locale, AutocompleteToolbarStyle) -> AnyView
    
    /**
     This typealias represents the action block that is used
     to trigger a text replacement when tapping a suggestion.
     */
    public typealias ReplacementAction = (AutocompleteSuggestion) -> Void
    
    /**
     This typealias represents the action block that is used
     to create autocomplete suggestion separator views.
     */
    public typealias SeparatorBuilder = (AutocompleteSuggestion, AutocompleteToolbarStyle) -> AnyView
    
    public var body: some View {
        HStack {
            ForEach(items) { item in
                itemButton(for: item.suggestion)
                if useSeparator(for: item) {
                    separatorBuilder(item.suggestion, style)
                }
            }
        }
    }
}

public extension CustomAutocompleteToolbar {
    
    /**
     This is the default function that will be used to build
     an item view for the provided `suggestion`.
     */
    static func standardItem(
        for suggestion: AutocompleteSuggestion,
        locale: Locale,
        style: AutocompleteToolbarStyle) -> AnyView {
        AnyView(AutocompleteToolbarItem(
            suggestion: suggestion,
            style: style.item,
            locale: locale)
        )
    }
    
    /**
     This is the default action that will be used to trigger
     a text replacement when a `suggestion` is tapped.
     */
    static func standardReplacementAction(for suggestion: AutocompleteSuggestion) {
        let actionHandler: DemtextKeyboardActionHandler = KeyboardInputViewController.shared.keyboardActionHandler as! DemtextKeyboardActionHandler
        actionHandler.tryReplaceSuggestions(for: suggestion)
    }
    
    /**
     This is the default function that will be used to build
     an item separator after the provided `suggestion`.
     */
    static func standardSeparator(
        for suggestion: AutocompleteSuggestion,
        style: AutocompleteToolbarStyle) -> AnyView {
        AnyView(AutocompleteToolbarSeparator(
            style: style.separator))
    }
}

private extension CustomAutocompleteToolbar {
    
    func itemButton(for suggestion: AutocompleteSuggestion) -> some View {
        Button(action: { self.replacementAction(suggestion) }, label: {
            itemBuilder(suggestion, locale, style)
                .padding(.horizontal, 4)
                .padding(.vertical, 10)
                .background(suggestion.isAutocomplete ? style.autocompleteBackground.color : Color.white.opacity(0.001))
                .cornerRadius(style.autocompleteBackground.cornerRadius)
        })
        .background(Color.white.opacity(0.001))
        .buttonStyle(PlainButtonStyle())
    }
}

private extension CustomAutocompleteToolbar {
    
    func isLast(_ item: BarItem) -> Bool {
        item.id == items.last?.id
    }
    
    func isNextItemAutocomplete(for item: BarItem) -> Bool {
        guard let index = (items.firstIndex { $0.id == item.id }) else { return false }
        let nextIndex = items.index(after: index)
        guard nextIndex < items.count else { return false }
        return items[nextIndex].suggestion.isAutocomplete
    }
    
    func useSeparator(for item: BarItem) -> Bool {
        if item.suggestion.isAutocomplete { return false }
        if isLast(item) { return false }
        return !isNextItemAutocomplete(for: item)
    }
}



private extension View {
    
    func previewBar() -> some View {
        self.background(Color.gray.opacity(0.3))
            .cornerRadius(10)
    }
}

