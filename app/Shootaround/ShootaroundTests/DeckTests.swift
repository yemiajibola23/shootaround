//
//  DeckTests.swift
//  ShootaroundTests
//
//  Created by Yemi Ajibola on 10/5/26.
//

import Testing
import Foundation
@testable import Shootaround

struct DeckTests {

    @Test func deckInitializesFromCSVText() {
        // 1. Create a Deck from the text "AI Engineering" using Deck(rawValue:)
        let deck1 = Deck(rawValue: "AI Engineering")
        // 2. #expect the result equals .aiEngineering
        #expect(deck1 == .aiEngineering)
        // 3. Repeat steps 1-2 for "iOS" -> .ios,
        //    "Basketball Data" -> .basketballData, "Behavioral" -> .behavioral
        let deck2 = Deck(rawValue: "iOS")
        #expect(deck2 == .ios)
        
        let deck3 = Deck(rawValue: "Basketball Data")
        #expect(deck3 == .basketballData)
        
        let deck4 = Deck(rawValue: "Behavioral")
        #expect(deck4 == .behavioral)
        
        
        // 4. Create a Deck from "Cooking", which is not a real deck
        // 5. #expect the result is nil
        let deck5 = Deck(rawValue: "Cooking")
        #expect(deck5 == nil)
        
    }
    
    @Test func cardKindInitializesFromCSVText() {
        // 1. Create a CardKind from "recall" and #expect it equals .recall
        let kind1 = CardKind(rawValue: "recall")
        #expect(kind1 == .recall)
        // 2. Same for "explain" -> .explain and "code" -> .code
        let kind2 = CardKind(rawValue: "explain")
        #expect(kind2 == .explain)

        let kind3 = CardKind(rawValue: "code")
        #expect(kind3 == .code)

        // 3. Create a CardKind from "flashcard", which is not a kind
        // 4. #expect that result is nil
        
        let kind4 = CardKind(rawValue: "flashcard")
        #expect(kind4 == nil)
        
    }

    @Test func cardSourceInitializesFromCSVText() {
        // 1. Create a CardSource from "manual" and #expect it equals .manual
        let source1 = CardSource(rawValue: "manual")
        #expect(source1 == .manual)
        
        // 2. Same for "generated" -> .generated and "jobAssistant" -> .jobAssistant
        let source2 = CardSource(rawValue: "generated")
        #expect(source2 == .generated)
        
        let source3 = CardSource(rawValue: "jobAssistant")
        #expect(source3 == .jobAssistant)
        
        // 3. Create a CardSource from "import", which is not a source
        // 4. #expect that result is nil
        let source4 = CardSource(rawValue: "import")
        #expect(source4 == nil)
        
    }
    
    @Test func newCardStartsWithSM2Defaults() {
        // 1. Create a Card with Card(deck:concept:kind:prompt:answer:source:),
        //    using .ios, "structured concurrency", .recall,
        //    "What is a task group?", "A way to run child tasks in parallel", .manual
        let card = Card(deck: .ios, concept: "structured concurrency", kind: .recall, prompt: "What is a task group?", answer: "A way to run child tasks in parallel", source: .manual)
        
        // 2. #expect card.deck equals .ios and card.concept equals "structured concurrency"
        #expect(card.deck == .ios)
        #expect(card.concept == "structured concurrency")
        
        // 3. #expect card.ease equals 2.5
        #expect(card.ease == 2.5)
        
        // 4. #expect card.intervalDays equals 0
        #expect(card.intervalDays == 0)

        // 5. #expect card.repetitions equals 0
        #expect(card.repetitions == 0)

        // 6. #expect card.due is not in the future: card.due <= Date()
        //    (a brand-new card should be reviewable right away)
        #expect(card.due <= Date())
    }


    @Test func eachNewCardGetsItsOwnID() {
        // 1. Create two cards with identical arguments
        //    (any deck, concept, kind, prompt, answer, source)
        let card1 = Card(deck: .ios, concept: "structured concurrency", kind: .recall, prompt: "What is a task group?", answer: "A way to run child tasks in parallel", source: .manual)
        let card2 = Card(deck: .ios, concept: "structured concurrency", kind: .recall, prompt: "What is a task group?", answer: "A way to run child tasks in parallel", source: .manual)
        
        // 2. #expect their ids are not equal
        #expect(card1.id != card2.id)
    }
    
    @Test func cardIDIsAUUID() {
        // 1. Create a Card (any arguments)
        let card1 = Card(deck: .ios, concept: "structured concurrency", kind: .recall, prompt: "What is a task group?", answer: "A way to run child tasks in parallel", source: .manual)

        // 2. Assign card.id to a constant with an explicit type annotation: UUID
        //    (the compiler will refuse if it isn't one)
        let testId: UUID = card1.id
        // 3. #expect the constant is not the all-zeros UUID,
        //    i.e. != UUID(uuidString: "00000000-0000-0000-0000-000000000000")
        #expect(testId != UUID(uuidString: "00000000-0000-0000-0000-000000000000"))
    }

}

