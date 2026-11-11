//
//  ReviewView.swift
//  Shootaround
//

import SwiftUI
import SwiftData

struct ReviewView: View {
    @State private var session: ReviewSession

    init(cards: [Card], context: ModelContext) {
        // Build the session and give it to @State
        _session = State(wrappedValue: ReviewSession(cards: cards, context: context))
    }

    var body: some View {
        // Show the current card's prompt, or a "done" message
        VStack {
            Text(session.currentCard?.prompt ?? "Done")
            Button("Reveal") { session.reveal() }
            
            if session.isRevealed {
                Text(session.currentCard?.answer ?? "Done")
                Button("Grade") { session.grade(3, now: .now) }
            }
            
        }
    }
}
