//
//  DeckImportTests.swift
//  ShootaroundTests
//

import Testing
import SwiftData
import Foundation
@testable import Shootaround

func importDeck(_ csv: String, into context: ModelContext) throws -> Int {
    // 1. Parse the csv
    let deckImport = try parseDeck(csv)
    // 2. Fetch what's stored and collect the existing prompts
    var prompts: Set<String> = Set(try context.fetch(FetchDescriptor<Card>()).map { return $0.prompt })
    // 3. Insert only cards whose prompt isn't stored yet
    for card in deckImport {
        if !prompts.contains(card.prompt) {
            context.insert(card)
            prompts.insert(card.prompt)
        }
    }
    // 4. Save, then return the store's card count
    try context.save()
    
    return try context.fetch(FetchDescriptor<Card>()).count
}

struct DeckImportTests {

    @Test func importDeckInsertsEveryCard() throws {
        let csv = """
           deck,concept,kind,prompt,answer,source
           iOS,Swift enum raw values,recall,"What does `enum Deck: String` give you for free?","A failable initializer init?(rawValue:) that returns the matching case, or nil if the text matches no case",manual
           iOS,Swift enum raw values,code,"Write an enum Conference with raw type String, cases east and west, and text East and West.","enum Conference: String { case east = ""East""; case west = ""West"" }",manual
           """
        
        let temporaryDirectory = FileManager.default.temporaryDirectory
        let url = temporaryDirectory.appending(path: UUID().uuidString + ".store")
       
        let container = try! makeContainer(storeURL: url)
        let context = ModelContext(container)

        let count = try importDeck(csv, into: context)

        #expect(count == 2)
        #expect(try context.fetch(FetchDescriptor<Card>()).count == 2)
        
    }

    @Test func importingTwiceKeepsReviewProgress() throws {
        let temporaryDirectory = FileManager.default.temporaryDirectory
        let url = temporaryDirectory.appending(path: UUID().uuidString + ".store")
        
        let container = try! makeContainer(storeURL: url)
        let context = ModelContext(container)
        
        let csv = """
           deck,concept,kind,prompt,answer,source
           iOS,Swift enum raw values,recall,"What does `enum Deck: String` give you for free?","A failable initializer init?(rawValue:) that returns the matching case, or nil if the text matches no case",manual
           iOS,Swift enum raw values,code,"Write an enum Conference with raw type String, cases east and west, and text East and West.","enum Conference: String { case east = ""East""; case west = ""West"" }",manual
           """
        
        let prompt = "What does `enum Deck: String` give you for free?"
    
        let count = try importDeck(csv, into: context)
        #expect(count == 2)

        
        let cards = try context.fetch(FetchDescriptor<Card>())
        let card = cards.first(where: { $0.prompt == prompt })
        card?.repetitions = 3
        
        let secondCount = try importDeck(csv, into: context)
        let secondCardsDraw = try context.fetch(FetchDescriptor<Card>())
        let match = secondCardsDraw.first(where: { $0.prompt == prompt })


        #expect(secondCount == 2)
        #expect(match?.repetitions == 3)
    }

    @Test func duplicatePromptInOneCSVIsImportedOnce() throws {
        // 1. Temp-file store and context
        let temporaryDirectory = FileManager.default.temporaryDirectory
        let url = temporaryDirectory.appending(path: UUID().uuidString + ".store")
        
        let container = try! makeContainer(storeURL: url)
        let context = ModelContext(container)
        // 2. csv = header + 2 rows that share the same prompt
        let csv = """
           deck,concept,kind,prompt,answer,source
           AI Engineering,Swift enum raw values,recall,"What does `enum Deck: String` give you for free?","A failable initializer init?(rawValue:) that returns the matching case, or nil if the text matches no case",manual
           iOS,Swift enum raw values,code,"What does `enum Deck: String` give you for free?","enum Conference: String { case east = ""East""; case west = ""West"" }",manual
           """
        // 3. try importDeck(csv, into: context)
        let cardCount = try importDeck(csv, into: context)
        // 4. #expect the number of Cards in the store == 1
        #expect(cardCount == 1)
    }

}
