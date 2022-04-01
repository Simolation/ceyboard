//
//  DispatchQueueExtension.swift
//  demtext
//
//  Created by Simon Osterlehner on 19.02.22.
//

import Foundation

extension DispatchQueue {
    
    static func background<T>(background: @escaping (()->T), completion: ((T) -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            // Run task in background
            let result = background()
            
            // When a main thread completion should be performed, pass the background result to the main thread
            if let completion = completion {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
}
