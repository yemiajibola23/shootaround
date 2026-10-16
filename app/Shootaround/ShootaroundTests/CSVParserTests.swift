//
//  CSVParserTests.swift
//  Shootaround
//
//  Created by Yemi Ajibola on 10/15/26.
//
import Testing
@testable import Shootaround

struct CSVParserTests {
    @Test func parsesValidRowIntoCard() throws {
        let row = "iOS,structured concurrency,recall,What is a task group?,A way to run child tasks in parallel,manual"
        
        let card = try parseRow(row)
        #expect(card.deck == .ios)
        #expect(card.concept == "structured concurrency")
        #expect(card.prompt == "What is a task group?")
        #expect(card.answer == "A way to run child tasks in parallel")
        #expect(card.source == .manual)
        #expect(card.kind == .recall)
    }
    
    @Test func throwsWhenRowHasWrongColumnCount() {
        let row = "iOS,structured concurrency,recall"
        #expect(throws: CardRowError.wrongColumnCount(3)) {
            try parseRow(row)
        }
    }
    
    @Test func throwsWhenEnumTextDoesNotMatch() {
        
        let badDeckRow = "blah blah,structured concurrency,recall,What is a task group?,A way to run child tasks in parallel,manual"
        let badKindRow = "iOS,structured concurrency,blah blah,What is a task group?,A way to run child tasks in parallel,manual"
        let badSourceRow = "iOS,structured concurrency,recall,What is a task group?,A way to run child tasks in parallel,blah blah"


        // 2. Three #expect(throws:) checks, one per row.
        //    Each expects the specific error case, carrying the exact bad text you used.
        #expect(throws: CardRowError.badDeck("blah blah")) { try parseRow(badDeckRow) }
        #expect(throws: CardRowError.badKind("blah blah")) { try parseRow(badKindRow) }
        #expect(throws: CardRowError.badSource("blah blah")) { try parseRow(badSourceRow) }

    }
}
