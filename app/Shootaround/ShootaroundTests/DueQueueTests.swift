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
        let temporaryDirectory = FileManager.default.temporaryDirectory
        let url = temporaryDirectory.appending(path: UUID().uuidString + ".store")
        
        let container = try makeContainer(storeURL: url)
        let context = ModelContext(container)
        
        
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
}
