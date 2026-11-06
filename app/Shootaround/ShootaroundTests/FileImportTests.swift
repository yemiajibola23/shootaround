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
        let temporaryDirectory = FileManager.default.temporaryDirectory
        let url = temporaryDirectory.appending(path: UUID().uuidString + ".csv")
        
        let csv = """
            deck,concept,kind,prompt,answer,source
            iOS,Swift optionals,recall,"What does nil mean for an optional?","The optional holds no value",manual
            """
        try csv.write(to: url, atomically: false, encoding: .utf8)

        let res = try readDeck(from: url)

        #expect(res == csv)
    }

    @Test func importDeckFileImportsCardsFromAFile() throws {
        // 1. Write a 2-card CSV to a temp .csv file
        let temporaryDirectory = FileManager.default.temporaryDirectory
        let url = temporaryDirectory.appending(path: UUID().uuidString + ".csv")
        let csv = """
           deck,concept,kind,prompt,answer,source
           iOS,Swift optionals,recall,"What does nil mean for an optional?","The optional holds no value",manual
           iOS,structured concurrency,recall,"What is a class, a struct, and an enum?","A class is an object that is passed by reference, a struct is a object that is passed by value, an enum is a data type used to group values",manual
           """
        try csv.write(to: url, atomically: false, encoding: .utf8)
        
        // 2. Make a container on a temp .store file, then a context from it
        let storeURL = temporaryDirectory.appending(path: UUID().uuidString + ".store")
        let container = try makeContainer(storeURL: storeURL)
        let context = ModelContext(container)
        
        // 3. Call importDeckFile(from:into:)
        let res = try importDeckFile(from: url, into: context)
        // 4. Expect the returned count and the fetched Card count
        #expect(res == 2)
        #expect(try context.fetch(FetchDescriptor<Card>()).count == 2)
    }
}

func importDeckFile(from url: URL, into context: ModelContext) throws -> Int {
    let  text = try readDeck(from: url)

    return try importDeck(text, into: context)
}
