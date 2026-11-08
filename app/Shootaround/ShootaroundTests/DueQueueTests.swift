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
        // 1. Make a fresh store: temp-file URL (UUID + ".store"), makeContainer(storeURL:),
        //    then a ModelContext made from that container
        let temporaryDirectory = FileManager.default.temporaryDirectory
        let url = temporaryDirectory.appending(path: UUID().uuidString + ".store")
        
        let container = try makeContainer(storeURL: url)
        let context = ModelContext(container)
        
        
        // 2. Pin "now" to a fixed date, e.g. Date(timeIntervalSince1970: 1_800_000_000)
        let now = Date(timeIntervalSince1970: 1_800_000_000)
        // 3. Make three Cards (any deck/concept/kind/prompt/answer/source).
        //    Card's init has no `due` parameter, so set `.due` after creating each one:
        //      - "overdue":  due = now minus 2 days  (now.addingTimeInterval(-2 * 86_400))
        //      - "dueNow":   due = now
        //      - "future":   due = now plus 1 day
        let card1 = Card(deck: .basketballData, concept: "Test1", kind: .explain, prompt: "overdue", answer: "Answer 1", source: .manual)
        card1.due = now.addingTimeInterval(-2 * 86_400)
    
        let card2 = Card(deck: .basketballData, concept: "Test2", kind: .explain, prompt: "dueNow", answer: "Answer 2", source: .manual)
        card2.due = now
        
        let card3 = Card(deck: .basketballData, concept: "Test2", kind: .explain, prompt: "future", answer: "Answer 3", source: .manual)
        card3.due = now.addingTimeInterval(86_400)
        
        // 4. Insert them out of order (future, dueNow, overdue), then save the context
        context.insert(card3)
        context.insert(card2)
        context.insert(card1)
        
        try context.save()
        // 5. Fetch with dueCardsDescriptor(now:) and keep the result in `due`
        let due = try context.fetch(dueCardsDescriptor(now: now))
        
        // 6. #expect the prompts of `due`, mapped in order, equal ["overdue", "dueNow"]
        //    Hint: due.map(\.prompt)
        #expect(due.map(\.prompt) == ["overdue", "dueNow"])
    }
}
