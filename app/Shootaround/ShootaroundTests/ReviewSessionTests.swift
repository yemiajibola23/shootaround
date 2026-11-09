//
//  ReviewSessionTests.swift
//  ShootaroundTests
//

import Testing
import SwiftData
import Foundation
import Observation
@testable import Shootaround

// MARK: - System under test (moves into the app target once green)

@Observable final class ReviewSession {
    var cards: [Card]
    var isRevealed = false

    init(cards: [Card]) {
        self.cards = cards
    }

    func reveal() { isRevealed = true }
}

// MARK: - Tests

struct ReviewSessionTests {
    @Test func revealShowsTheAnswer() {
        let card1 = Card(deck: .ios, concept: "structured concurrency", kind: .recall, prompt: "What is a task group?", answer: "A way to run child tasks in parallel", source: .manual)

        let sut = ReviewSession(cards: [card1])

        #expect(sut.isRevealed == false)
        sut.reveal()
        #expect(sut.isRevealed == true)
    }
}
