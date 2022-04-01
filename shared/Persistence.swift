//
//  Persistence.swift
//  demtext
//
//  Created by Simon Osterlehner on 03.11.21.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let persistentHistoryObserverApp: PersistentHistoryObserver
    let persistentHistoryObserverExtension: PersistentHistoryObserver

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    private static let _container: NSPersistentContainer = {
        NSPersistentContainer(name: "ceyboard")
    }()
    
    var container: NSPersistentContainer {
        PersistenceController._container
    }

    init(inMemory: Bool = false) {
        
        if inMemory {
            PersistenceController._container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else {
            let storeURL = URL.storeURL(for: SuiteName.name, databaseName: "ceyboard")
            let storeDescription = NSPersistentStoreDescription(url: storeURL)
            storeDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            storeDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
            
            PersistenceController._container.persistentStoreDescriptions = [storeDescription]
        }
        
        PersistenceController._container.viewContext.name = "view_context"
        PersistenceController._container.viewContext.transactionAuthor = "main_app"
        
        PersistenceController._container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })        
        let userDefaults = UserDefaults(suiteName: SuiteName.name)
        
        persistentHistoryObserverApp = PersistentHistoryObserver(target: .app, persistentContainer: PersistenceController._container, userDefaults: userDefaults ?? UserDefaults())
        persistentHistoryObserverExtension = PersistentHistoryObserver(target: .keyboardExtension, persistentContainer: PersistenceController._container, userDefaults: userDefaults ?? UserDefaults())
        
        persistentHistoryObserverApp.startObserving()
        persistentHistoryObserverExtension.startObserving()
    }
}

public extension URL {

    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
