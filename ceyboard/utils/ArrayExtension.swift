//
//  ArrayExtension.swift
//  ceyboard
//
//  Created by Simon Osterlehner on 26.02.22.
//

import Foundation

extension Array where Element: FloatingPoint {
    
    /// Calculate the sum of all array items
    func sum() -> Element {
        return self.reduce(0, +)
    }
    
    /// Calculate the mean of all array items
    func mean() -> Element {
        if self.count == 0 {
            return 0
        }
        
        return self.sum() / Element(self.count)
    }
    
    /// Calculate the standard deviation
    func std() -> Element {
        // Return 0 when less than 2 elements are available
        if self.count < 2 {
            return 0
        }
        
        let mean = self.mean()
        let sumSquare = self.reduce(0, { $0 + ($1 - mean) * ($1 - mean) })
        return sqrt(sumSquare / (Element(self.count) - 1))
    }
    
}
