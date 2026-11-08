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

        let deck1 = Deck(rawValue: "AI Engineering")

        #expect(deck1 == .aiEngineering)

        let deck2 = Deck(rawValue: "iOS")
        #expect(deck2 == .ios)
        
        let deck3 = Deck(rawValue: "Basketball Data")
        #expect(deck3 == .basketballData)
        
        let deck4 = Deck(rawValue: "Behavioral")
        #expect(deck4 == .behavioral)
        
        let deck5 = Deck(rawValue: "Cooking")
        #expect(deck5 == nil)
        
    }
    
    @Test func cardKindInitializesFromCSVText() {
        let kind1 = CardKind(rawValue: "recall")
        #expect(kind1 == .recall)

        let kind2 = CardKind(rawValue: "explain")
        #expect(kind2 == .explain)

        let kind3 = CardKind(rawValue: "code")
        #expect(kind3 == .code)
        
        let kind4 = CardKind(rawValue: "flashcard")
        #expect(kind4 == nil)
        
    }

    @Test func cardSourceInitializesFromCSVText() {
        let source1 = CardSource(rawValue: "manual")
        #expect(source1 == .manual)
        
        let source2 = CardSource(rawValue: "generated")
        #expect(source2 == .generated)
        
        let source3 = CardSource(rawValue: "jobAssistant")
        #expect(source3 == .jobAssistant)
        
        let source4 = CardSource(rawValue: "import")
        #expect(source4 == nil)
        
    }
    
    @Test func newCardStartsWithSM2Defaults() {
        let card = Card(deck: .ios, concept: "structured concurrency", kind: .recall, prompt: "What is a task group?", answer: "A way to run child tasks in parallel", source: .manual)
        
        #expect(card.deck == .ios)
        #expect(card.concept == "structured concurrency")
        
        #expect(card.ease == 2.5)
        
        #expect(card.intervalDays == 0)

        #expect(card.repetitions == 0)

        #expect(card.due <= Date())
    }


    @Test func eachNewCardGetsItsOwnID() {
        let card1 = Card(deck: .ios, concept: "structured concurrency", kind: .recall, prompt: "What is a task group?", answer: "A way to run child tasks in parallel", source: .manual)
        let card2 = Card(deck: .ios, concept: "structured concurrency", kind: .recall, prompt: "What is a task group?", answer: "A way to run child tasks in parallel", source: .manual)
        
        #expect(card1.id != card2.id)
    }
    
    @Test func cardIDIsAUUID() {
        let card1 = Card(deck: .ios, concept: "structured concurrency", kind: .recall, prompt: "What is a task group?", answer: "A way to run child tasks in parallel", source: .manual)

        let testId: UUID = card1.id

        #expect(testId != UUID(uuidString: "00000000-0000-0000-0000-000000000000"))
    }

}

