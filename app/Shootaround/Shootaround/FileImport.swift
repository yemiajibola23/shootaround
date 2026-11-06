//
//  FileImport.swift
//  Shootaround
//

import Foundation
import SwiftData

func readDeck(from url: URL) throws -> String {
    let granted = url.startAccessingSecurityScopedResource()
    defer { if granted { url.stopAccessingSecurityScopedResource() } }

    return try String(contentsOf: url, encoding: .utf8)
}

func importDeckFile(from url: URL, into context: ModelContext) throws -> Int {
    let  text = try readDeck(from: url)

    return try importDeck(text, into: context)
}
