//
//  ceyboardApp.swift
//  ceyboard
//
//  Created by Simon Osterlehner on 03.11.21.
//

import SwiftUI
import KeyboardKit

@main
struct ceyboardApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var keyboardState = KeyboardEnabledState(bundleId: SuiteName.keyboardName)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(keyboardState)
        }
    }
}
