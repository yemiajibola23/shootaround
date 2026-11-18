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

#Preview {
    ContentView()
}
