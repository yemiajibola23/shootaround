//
//  DeckParserTests.swift
//  ShootaroundTests
//
//  Created by Yemi Ajibola on 10/18/26.
//

import Testing
@testable import Shootaround

struct DeckParserTests {
    @Test func keepsCommaInsideQuotes() {
        let text = #"a,"b,c""#
        let result = splitFields(text)
        // 3. #expect the result == ["a", "b,c"]
        #expect(result == ["a", "b,c"])
        
    }

    @Test func parsesHeaderAndRowsIntoCards() throws {
        // Build a small CSV: header + 2 rows, one with a quoted comma
        let deck = """
           deck,concept,kind,prompt,answer,source
           iOS,Swift optionals,recall,"What does nil mean for an optional?","The optional holds no value",manual
           iOS,structured concurrency,recall,"What is a class, a struct, and an enum?","A class is an object that is passed by reference, a struct is a object that is passed by value, an enum is a data type used to group values",manual
           """
        let sut = try parseDeck(deck)
        // Expect 2 cards and check one prompt
        #expect(sut.count == 2)
        #expect(sut.first?.prompt == "What does nil mean for an optional?")
        #expect(sut.last?.prompt == "What is a class, a struct, and an enum?")
    }
}
