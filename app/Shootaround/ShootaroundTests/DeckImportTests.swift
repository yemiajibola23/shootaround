//
//  DeckImportTests.swift
//  ShootaroundTests
//

import Testing
import SwiftData
import Foundation
@testable import Shootaround

struct DeckImportTests {

    @Test func importDeckInsertsEveryCard() throws {
        let csv = """
           deck,concept,kind,prompt,answer,source
           iOS,Swift enum raw values,recall,"What does `enum Deck: String` give you for free?","A failable initializer init?(rawValue:) that returns the matching case, or nil if the text matches no case",manual
           iOS,Swift enum raw values,code,"Write an enum Conference with raw type String, cases east and west, and text East and West.","enum Conference: String { case east = ""East""; case west = ""West"" }",manual
           """
        
        let context = try makeTestContext()
        let count = try importDeck(csv, into: context)

        #expect(count == 2)
        #expect(try context.fetch(FetchDescriptor<Card>()).count == 2)
        
    }

    @Test func importingTwiceKeepsReviewProgress() throws {
        let context = try makeTestContext()
        
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
        let context = try makeTestContext()

        let csv = """
           deck,concept,kind,prompt,answer,source
           AI Engineering,Swift enum raw values,recall,"What does `enum Deck: String` give you for free?","A failable initializer init?(rawValue:) that returns the matching case, or nil if the text matches no case",manual
           iOS,Swift enum raw values,code,"What does `enum Deck: String` give you for free?","enum Conference: String { case east = ""East""; case west = ""West"" }",manual
           """

        let cardCount = try importDeck(csv, into: context)

        #expect(cardCount == 1)
    }

}
