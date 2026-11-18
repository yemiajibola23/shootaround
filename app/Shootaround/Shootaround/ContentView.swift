//
//  ContentView.swift
//  Shootaround
//
//  Created by Yemi Ajibola on 10/5/26.
//

import SwiftUI
import SM2Scheduler
import SwiftData
internal import UniformTypeIdentifiers


struct ContentView: View {
    @State private var isImporting = false
    @State private var selectedDeck: Deck? = nil
    @Environment(\.modelContext) private var context
    
    var body: some View {
        VStack {
            Picker("Select a Deck", selection: $selectedDeck) {
                ForEach(Deck.allCases) {
                    Text($0.rawValue)
                        .tag($0 as Deck?)
                }
                
                Text("All Decks")
                    .tag(nil as Deck?)
            }
            DueListView(deck: selectedDeck)
            Button("Import Deck") { isImporting = true }
                .fileImporter(isPresented: $isImporting, allowedContentTypes: [.commaSeparatedText]) { result in
                    switch result {
                    case .success(let url):
                        do {
                            let count = try importDeckFile(from: url, into: context)
                            print("Imported: store has \(count) cards.")
                            
                        } catch {
                            print(error)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
                
        }
        .padding()
    }
}

struct DueListView: View {
    @Query private var dueCards: [Card]
    @State private var isReviewing = false
    @Environment(\.modelContext) private var context

    init(deck: Deck?, now: Date = .now) {
        _dueCards = Query(dueCardsDescriptor(now: now, deck: deck))
    }

    var body: some View {
        VStack {
            Text("List count: \(dueCards.count)")
            List(dueCards) { Text($0.prompt) }
            Button("Start Review") { isReviewing = true }
                .sheet(isPresented: $isReviewing){ ReviewView(cards: dueCards, context: context) }
        }

    }
}

#Preview {
    ContentView()
}
