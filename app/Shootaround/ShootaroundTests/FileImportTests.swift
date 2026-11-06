//
//  FileImportTests.swift
//  ShootaroundTests
//

import Testing
import Foundation
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
}

func readDeck(from url: URL) throws -> String {
    // 1. Start access: url.startAccessingSecurityScopedResource() returns a Bool. Keep it.
    let granted = url.startAccessingSecurityScopedResource()
    // 2. Schedule the stop with defer, only if access was granted.
    defer { if granted { url.stopAccessingSecurityScopedResource() } }
    // 3. Read and return the text: try String(contentsOf:encoding:)
    return try String(contentsOf: url, encoding: .utf8)
}
