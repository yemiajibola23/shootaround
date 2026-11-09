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
    let context: ModelContext

    init(cards: [Card], context: ModelContext) {
        self.cards = cards
        self.context = context
    }

    func reveal() { isRevealed = true }

    func grade(_ value: Int, now: Date, calendar: Calendar = .current) {
        guard isRevealed, cards.indices.contains(currentIndex) else { return }

        let card = cards[currentIndex]
        let state = sm2Update(SM2State(card: cards[currentIndex]), grade: value)

        card.ease = state.ease
        card.intervalDays = state.intervalDays
        card.repetitions = state.repetitions

        card.due = dueDate(reviewDate: now, intervalDays: card.intervalDays, calendar: calendar)
        // 5. Insert a Review (cardID, reviewedAt: now, grade: value) into context
        let review = Review(cardID: card.id, reviewedAt: now, grade: value, typedAnswer: card.answer, aiScore: nil)
        context.insert(review)

        // I chose do/catch to capture the error to display to the user.
        do {
            try context.save()
            print("REVIEW CHECK: Saved review with card id: \(review.cardID) successfully!")
        } catch {
            print("REVIEW CHECK:  \(error)")
        }
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
        let testContext = try! makeTestContext()
        
        let sut = ReviewSession(cards: [card1], context: testContext)

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
        let testContext = try! makeTestContext()

        let sut = ReviewSession(cards: [card1], context: testContext)
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
        let context = try! makeTestContext()
        let sut = ReviewSession(cards: [], context: context)
        sut.reveal()
        // 2. Call grade(4, now:, calendar:)
        sut.grade(4, now: .now)
        // 3. Expect isRevealed is still true (we got here without crashing)
        #expect(sut.isRevealed)
    }

    @Test func gradingLogsAReview() throws {
        // 1. Make a context with makeTestContext(), insert a card, make a
        //    session with that card and context, and reveal it
        let card1 = Card(deck: .ios, concept: "structured concurrency", kind: .recall, prompt: "What is a task group?", answer: "A way to run child tasks in parallel", source: .manual)
        let context = try makeTestContext()
        let sut = ReviewSession(cards: [card1], context: context)
        sut.reveal()
        // 2. Grade it 4 with a fixed now
        let now = Date(timeIntervalSince1970: 1_800_000_000)
        sut.grade(4, now: now)
        // 3. Fetch every Review from the context
        let reviews = try context.fetch(FetchDescriptor<Review>())
        
        // 4. Expect exactly one, with the card's id, grade 4 and reviewedAt == now
        #expect(reviews.count == 1)
        let review = reviews.first
        #expect(review?.cardID == card1.id)
        #expect(review?.grade == 4)
        #expect(review?.reviewedAt == now)
    }
}
