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
    @Environment(\.modelContext) private var context
    @Query private var dueCards: [Card]
    @State private var isReviewing = false
    
    init(now: Date = .now) {
        _dueCards = Query(dueCardsDescriptor(now: now))
    }
    
    var body: some View {
        VStack {
            Text("List count: \(dueCards.count)")
            List(dueCards) { Text($0.prompt)}
            Button("Start Review") { isReviewing = true }
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
                .sheet(isPresented: $isReviewing){ ReviewView(cards: dueCards, context: context) }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
