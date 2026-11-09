//
//  FileImportTests.swift
//  ShootaroundTests
//

import Testing
import Foundation
import SwiftData
@testable import Shootaround

struct FileImportTests {

    @Test func readsTextFromAFileURL() throws {
        let url = testURL(ext: ".csv")
        
        let csv = """
            deck,concept,kind,prompt,answer,source
            iOS,Swift optionals,recall,"What does nil mean for an optional?","The optional holds no value",manual
            """
        try csv.write(to: url, atomically: false, encoding: .utf8)

        let res = try readDeck(from: url)

        #expect(res == csv)
    }

    @Test func importDeckFileImportsCardsFromAFile() throws {
        let url = testURL(ext: ".csv")

        let csv = """
           deck,concept,kind,prompt,answer,source
           iOS,Swift optionals,recall,"What does nil mean for an optional?","The optional holds no value",manual
           iOS,structured concurrency,recall,"What is a class, a struct, and an enum?","A class is an object that is passed by reference, a struct is a object that is passed by value, an enum is a data type used to group values",manual
           """
        try csv.write(to: url, atomically: false, encoding: .utf8)
        
        let context = try makeTestContext()
        let res = try importDeckFile(from: url, into: context)

        #expect(res == 2)
        #expect(try context.fetch(FetchDescriptor<Card>()).count == 2)
    }
}
