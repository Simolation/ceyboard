//
//  EventListView.swift
//  ceyboard
//
//  Created by Simon Osterlehner on 22.12.21.
//

import SwiftUI

struct EventListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest
    private var events: FetchedResults<SessionEvent>
    
    private var session: Session
    
    init(with session: Session) {
        self.session = session
        
        // Fetch the session events for the selected session
        _events = FetchRequest<SessionEvent>(
            entity: SessionEvent.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \SessionEvent.created_at, ascending: true)
            ],
            predicate: NSPredicate(format: "session == %@", session)
        )
    }
    
    var body: some View {
        Group {
            Text(session.hostApp ?? "Unknown App").font(.headline)
            Text("\"\(session.fullText ?? "No text")\"").padding()
            session.started_at != nil ? Text("at \(session.started_at!, formatter: itemFormatter)") : nil
            List {
                ForEach(events) { event in
                    HStack {
                        Text(formatEvent(event: event))
                        Spacer()
                        Text(event.action ?? "").font(.footnote).foregroundColor(.gray)
                    }
                }
            }
        }
    }
    
    /**
     Format the event to print out the value
     */
    private func formatEvent(event: SessionEvent) -> String {
        switch event.action {
        case "autocorrect":
            return "\(event.originalValue ?? "") -> \(event.value ?? "")"
        case "autocomplete":
            return "\(event.originalValue ?? "") -> \(event.value ?? "")"
        default:
            return event.value ?? ""
        }
    }
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
}

