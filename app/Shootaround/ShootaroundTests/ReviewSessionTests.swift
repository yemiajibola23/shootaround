//
//  ReviewSessionTests.swift
//  ShootaroundTests
//

import Testing
import SwiftData
import Foundation
import Observation
import SM2Scheduler
@testable import Shootaround

// MARK: - System under test (moves into the app target once green)

@Observable final class ReviewSession {
    var cards: [Card]
    var isRevealed = false
    var currentIndex = 0

    init(cards: [Card]) {
        self.cards = cards
    }

    func reveal() { isRevealed = true }

    func grade(_ value: Int, now: Date, calendar: Calendar = .current) {
        // 1. Only continue if the answer is revealed and a card exists at currentIndex
        guard isRevealed, cards.indices.contains(currentIndex) else { return }
        // 2. Run sm2Update on that card's current SM-2 state
        let card = cards[currentIndex]
        let state = sm2Update(SM2State(card: cards[currentIndex]), grade: value)
        // 3. Write the new ease, intervalDays and repetitions back onto the card
        card.ease = state.ease
        card.intervalDays = state.intervalDays
        card.repetitions = state.repetitions
        // 4. Set the card's due date with dueDate(reviewDate:intervalDays:calendar:)
        card.due = dueDate(reviewDate: now, intervalDays: card.intervalDays, calendar: calendar)
    }
}

extension SM2State {
    init(card: Card) {
        self.init(ease: card.ease, intervalDays: card.intervalDays, repetitions: card.repetitions)
    }
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

    @Test func gradingUpdatesTheCardsSchedule() {
        let card1 = Card(deck: .ios, concept: "structured concurrency", kind: .recall, prompt: "What is a task group?", answer: "A way to run child tasks in parallel", source: .manual)
        let now = Date(timeIntervalSince1970: 1_800_000_000)
        let calendar = Calendar.current
        
        let state = SM2State(card: card1)
        let expectedState = sm2Update(state, grade: 4)
        let expectedDueDate = dueDate(reviewDate: now, intervalDays: expectedState.intervalDays, calendar: calendar)
        
        // 2. Grade it 4 with a fixed now and calendar
        let sut = ReviewSession(cards: [card1])
        sut.reveal()
        sut.grade(4, now: now, calendar: calendar)


        // 3. Expect repetitions, intervalDays and due to match what
        //    sm2Update and dueDate return for the same inputs
        #expect(card1.repetitions == expectedState.repetitions)
        #expect(card1.intervalDays == expectedState.intervalDays)
        #expect(card1.due == expectedDueDate)
        
    }
    
    @Test func gradingAnEmptySessionDoesNothing() {
        // 1. Make a session with no cards and reveal it
        let sut = ReviewSession(cards: [])
        sut.reveal()
        // 2. Call grade(4, now:, calendar:)
        sut.grade(4, now: .now)
        // 3. Expect isRevealed is still true (we got here without crashing)
        #expect(sut.isRevealed)
    }
        
}
