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
        // 1. Make a unique temp URL: FileManager.default.temporaryDirectory
        //    + a UUID name ending in ".csv"
        let temporaryDirectory = FileManager.default.temporaryDirectory
        let url = temporaryDirectory.appending(path: UUID().uuidString + ".csv")
        
        // 2. Write a small CSV string there: try text.write(to:atomically:encoding:)
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
        // 2. Make a container on a temp .store file, then a context from it
        // 3. Call importDeckFile(from:into:)
        // 4. Expect the returned count and the fetched Card count
    }
}

func importDeckFile(from url: URL, into context: ModelContext) throws -> Int {
    // 1. Read the file's text with readDeck(from:)
    // 2. Hand that text to importDeck(_:into:) and return its count
}
