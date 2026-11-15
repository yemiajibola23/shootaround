//
//  DueQueueTests.swift
//  ShootaroundTests
//

import Testing
import SwiftData
import Foundation
@testable import Shootaround

// MARK: - Tests

struct DueQueueTests {

    @Test func dueDescriptorReturnsOnlyDueCardsSoonestFirst() throws {
        let context = try makeTestContext()
        
        let now = Date(timeIntervalSince1970: 1_800_000_000)
        
        let card1 = Card(deck: .basketballData, concept: "Test1", kind: .explain, prompt: "overdue", answer: "Answer 1", source: .manual)
        card1.due = now.addingTimeInterval(-2 * 86_400)
        let card2 = Card(deck: .basketballData, concept: "Test2", kind: .explain, prompt: "dueNow", answer: "Answer 2", source: .manual)
        card2.due = now
        let card3 = Card(deck: .basketballData, concept: "Test2", kind: .explain, prompt: "future", answer: "Answer 3", source: .manual)
        card3.due = now.addingTimeInterval(86_400)
        
        context.insert(card3)
        context.insert(card2)
        context.insert(card1)
        try context.save()
        
        let due = try context.fetch(dueCardsDescriptor(now: now))
        
        #expect(due.map(\.prompt) == ["overdue", "dueNow"])
    }

    @Test func dueDescriptorFiltersByDeck() throws {
        // 1. Make a test context; fix `now` as in the test above
        let context = try makeTestContext()
        let now = Date(timeIntervalSince1970: 1_800_000_000)
        // 2. Two cards due before now, same due date: one .ios, one .aiEngineering
        let card1 = Card(deck: .ios, concept: "Test1", kind: .explain, prompt: "overdue", answer: "Answer 1", source: .manual)
        card1.due = now.addingTimeInterval(-2 * 86_400)
        let card2 = Card(deck: .aiEngineering, concept: "Test2", kind: .explain, prompt: "dueNow", answer: "Answer 2", source: .manual)
        card2.due = now.addingTimeInterval(-2 * 86_400)
        let card3 = Card(deck: .ios, concept: "Test3", kind: .explain, prompt: "future", answer: "Answer 3", source: .manual)
        card3.due = now.addingTimeInterval(86_400)

        // 3. Insert both, then save
        context.insert(card1)
        context.insert(card2)
        context.insert(card3)
        
        try context.save()
        
        // 4. Fetch dueCardsDescriptor(now: now, deck: .ios)
        let sut = try context.fetch(dueCardsDescriptor(now: now, deck: .ios))
        // 5. #expect the prompts equal only the iOS card's prompt
        #expect(sut.map(\.prompt) == ["overdue"])
    }
}
