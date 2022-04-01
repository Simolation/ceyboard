//
//  CharacterRelation.swift
//  demtext
//
//  Created by Simon Osterlehner on 17.02.22.
//

import Foundation

class CharacterRelation {
    let allowedCharacters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    let sessions: [Session]
    
    var matrix: [[[Float]]] = []
    
    
    init(sessions: [Session]) {
        self.sessions = sessions
        
        self.initMatrix()
    }
    
    func initMatrix() {
        let count = self.allowedCharacters.count
        
        // Create a matrix with all character combinations
        self.matrix = Array(repeating: Array(repeating: [], count: count), count: count)
    }
    
    func isAllowedCharacterEvent(event: SessionEvent) -> Bool {
        if event.action == nil || event.action != "character" {
            return false
        }
        
        return self.allowedCharacters.contains(event.value?.lowercased() ?? "")
    }
    
    func findPosition(c1: String, c2: String) -> (Int, Int) {
        let row = allowedCharacters.firstIndex(of: c1.lowercased())!
        let column = allowedCharacters.firstIndex(of: c2.lowercased())!
        
        return (row, column)
    }
    
    func addValueToMatrix(e1: SessionEvent, e2: SessionEvent) {
        let pos = findPosition(c1: e1.value!, c2: e2.value!)
        
        // Calculate the time difference
        let timeDifference = Float(e2.created_at!.timeIntervalSince1970 - e1.created_at!.timeIntervalSince1970)
        
        // Add time difference to values
        self.matrix[pos.0][pos.1].append(timeDifference)
    }
    
    func calculateMeanAndStd() {
        for (i, element) in self.matrix.enumerated() {
            for (j, cell) in element.enumerated() {
                
                // Calculate the different metrics
                let count = Float(cell.count)
                let mean = cell.mean()
                let std = cell.std()
                
                // Store metrics back in the matrix
                self.matrix[i][j] = [count, mean, std]
            }
        }
    }

    
    func createRelations() -> [[[Float]]] {
        for session in sessions {
            // Get events
            var events = session.events?.allObjects as! [SessionEvent]
            
            // Sort events
            events = events.sorted(by: {
                $0.created_at!.compare($1.created_at!) == .orderedAscending
            })
            
            if events.isEmpty || events.count < 2 {
                continue
            }
            
            for i in 0...(events.count - 2) {
                let currentEvent = events[i]
                let nextEvent = events[i + 1]
                
                if self.isAllowedCharacterEvent(event: currentEvent) && self.isAllowedCharacterEvent(event: nextEvent) {
                    // Only add value to matrix if both events are valid
                    self.addValueToMatrix(e1: currentEvent, e2: nextEvent)
                }
            }
        }
        
        // Calculate metrics
        calculateMeanAndStd()
        
        return self.matrix
    }
}
