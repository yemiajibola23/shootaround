//
//  PersistenceTests.swift
//  ShootaroundTests
//
//  Created by Yemi Ajibola on 11/3/26.
//

import Testing
import SwiftData
import Foundation
@testable import Shootaround

func makeContainer(storeURL: URL?) throws -> ModelContainer {
    guard let url = storeURL else { return try ModelContainer(for: Card.self, configurations: ModelConfiguration()) }

    let config = ModelConfiguration(url: url)

    return try ModelContainer(for: Card.self, configurations: config)
}

struct PersistenceTests {

    @Test func cardSurvivesANewContainer() throws {
        let temporaryDirectory = FileManager.default.temporaryDirectory
        let url = temporaryDirectory.appending(path: UUID().uuidString + ".store")
        
        let first = try makeContainer(storeURL: url)
        var context = ModelContext(first)
        let card = Card(deck: .ios, concept: "structured concurrency", kind: .recall, prompt: "What is a task group?", answer: "A way to run child tasks in parallel", source: .manual)

        context.insert(card)
        try context.save()
        
        let second = try makeContainer(storeURL: url)
        context = ModelContext(second)

        let cards = try  context.fetch(FetchDescriptor<Card>())

        #expect(cards.count == 1)
    }

}
