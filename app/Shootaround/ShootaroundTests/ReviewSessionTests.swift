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
        

        let testContext = try! makeTestContext()

        let sut = ReviewSession(cards: [card1], context: testContext)
        sut.reveal()
        sut.grade(4, now: now, calendar: calendar)


        #expect(card1.repetitions == expectedState.repetitions)
        #expect(card1.intervalDays == expectedState.intervalDays)
        #expect(card1.due == expectedDueDate)
        
    }
    
    @Test func gradingAnEmptySessionDoesNothing() {

        let context = try! makeTestContext()
        let sut = ReviewSession(cards: [], context: context)
        sut.reveal()

        sut.grade(4, now: .now)

        #expect(sut.isRevealed)
    }

    @Test func gradingLogsAReview() throws {
        let card1 = Card(deck: .ios, concept: "structured concurrency", kind: .recall, prompt: "What is a task group?", answer: "A way to run child tasks in parallel", source: .manual)
        let context = try makeTestContext()
        let sut = ReviewSession(cards: [card1], context: context)
        sut.reveal()

        let now = Date(timeIntervalSince1970: 1_800_000_000)
        sut.grade(4, now: now)
        // 3. Fetch every Review from the context
        let reviews = try context.fetch(FetchDescriptor<Review>())
        

        #expect(reviews.count == 1)
        let review = reviews.first
        #expect(review?.cardID == card1.id)
        #expect(review?.grade == 4)
        #expect(review?.reviewedAt == now)
    }

    @Test func gradingAdvancesToTheNextCard() throws {
        let card1 = Card(deck: .ios, concept: "structured concurrency", kind: .recall, prompt: "What is a task group?", answer: "A way to run child tasks in parallel", source: .manual)
        let card2 = Card(deck: .ios, concept: "structured concurrency", kind: .recall, prompt: "What is grand central dispatch?", answer: "A way to run child tasks in parallel", source: .manual)
        let context = try makeTestContext()

        
        let sut = ReviewSession(cards: [card1, card2], context: context)
        sut.reveal()
        
        let now = Date(timeIntervalSince1970: 1_800_000_000)
        sut.grade(2, now: now)

        #expect(sut.currentIndex == 1)
        #expect(sut.isRevealed == false)
    }
    
    @Test func currentCardIsNilWhenTheSessionIsFinished() throws {
        let context = try makeTestContext()
        let card1 = Card(deck: .ios, concept: "structured concurrency", kind: .recall, prompt: "What is a task group?", answer: "A way to run child tasks in parallel", source: .manual)
        
        let sut = ReviewSession(cards: [card1], context: context)
    
        sut.reveal()
        sut.grade(4, now: .now)
        
        #expect(sut.currentCard == nil)
    }
    
    @Test func currentCardMovesToNextCardAfterGrading() throws {
        let context = try makeTestContext()
        let card1 = Card(deck: .ios, concept: "structured concurrency", kind: .recall, prompt: "What is a task group?", answer: "A way to run child tasks in parallel", source: .manual)
        let card2 = Card(deck: .ios, concept: "structured concurrency", kind: .recall, prompt: "What is grand central dispatch?", answer: "A way to run child tasks in parallel", source: .manual)

        let sut = ReviewSession(cards: [card1, card2], context: context)
    
        sut.reveal()
        sut.grade(4, now: .now)
        
        #expect(sut.currentCard === card2)
    }
    
    
    @Test func gradingLogsWhatWasTyped() throws {
        // set up a card and a session, reveal
        let context = try makeTestContext()
        let card1 = Card(deck: .ios, concept: "structured concurrency", kind: .recall, prompt: "What is a task group?", answer: "A way to run child tasks in parallel", source: .manual)
        
        let sut = ReviewSession(cards: [card1], context: context)
        let answer = "Wrong answer"
    
        sut.reveal()

        sut.grade(3, typedAnswer: answer, now: .now)

        let reviews = try context.fetch(FetchDescriptor<Review>())
        
        #expect(reviews.first?.typedAnswer == answer)
        
    }
}
