//
//  DueListView.swift
//  Shootaround
//

import SwiftUI
import SwiftData

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
