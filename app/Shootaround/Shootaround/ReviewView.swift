//
//  ReviewView.swift
//  Shootaround
//

import SwiftUI
import SwiftData

struct ReviewView: View {
    @State private var session: ReviewSession
    @State private var typed = ""

    init(cards: [Card], context: ModelContext) {
        // Build the session and give it to @State
        _session = State(wrappedValue: ReviewSession(cards: cards, context: context))
    }

    var body: some View {
        // Show the current card's prompt, or a "done" message
        VStack {
            Text(session.currentCard?.prompt ?? "Done")
            
            TextField("Your answer", text: $typed)
            
            Button("Reveal") { session.reveal() }
            
            if session.isRevealed {
                Text(session.currentCard?.answer ?? "Done")
                Text("Grade it")
                HStack {
                    ForEach(0..<6) { num in
                        Button("\(num)") {
                            session.grade(num, typedAnswer: typed == "" ? nil : typed, now: .now)
                            typed = ""
                        }
                    }
                }
            }
            
        }
    }
}
