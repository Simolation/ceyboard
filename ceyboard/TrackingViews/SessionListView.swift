//
//  SessionListView.swift
//  ceyboard
//
//  Created by Simon Osterlehner on 26.02.22.
//

import SwiftUI

struct SessionListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Session.started_at, ascending: false)],
        animation: .default)
    private var sessions: FetchedResults<Session>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sessions) { session in
                    NavigationLink {
                        // Navigate to the session event list
                        EventListView(with: session)
                    } label: {
                        if let fullText = session.fullText {
                            let appendix = fullText.count > 20 ? "..." : ""
                            Text((fullText.prefix(20)).filter{ $0 != "\n" } + appendix )
                        } else {
                            Text("No text")
                        }
                    }
                    
                }.onDelete(perform: deleteItems)
                
                if sessions.count == 0 {
                    Text("No sessions yet. Start typing!")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .navigationTitle("Sessions")
        }
    }
    
    /**
     Delete a session
     */
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { sessions[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct SessionListView_Previews: PreviewProvider {
    static var previews: some View {
        SessionListView()
    }
}
