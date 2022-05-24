//
//  PersistentHistoryCleaner.swift
//  ceyboard
//
//  Created by Constantin Ehmanns on 19.11.21.
//  Source: https://www.avanderlee.com/swift/persistent-history-tracking-core-data/

import Foundation
import CoreData

struct PersistentHistoryCleaner {

    let context: NSManagedObjectContext
    let targets: [AppTarget]
    let userDefaults: UserDefaults

    /// Cleans up the persistent history by deleting the transactions that have been merged into each target.
    func clean() throws {
        guard let timestamp = userDefaults.lastCommonTransactionTimestamp(in: targets) else {
            return
        }

        let deleteHistoryRequest = NSPersistentHistoryChangeRequest.deleteHistory(before: timestamp)
        try context.execute(deleteHistoryRequest)

        targets.forEach { target in
            /// Reset the dates as we would otherwise end up in an infinite loop.
            userDefaults.updateLastHistoryTransactionTimestamp(for: target, to: nil)
        }
    }
}
