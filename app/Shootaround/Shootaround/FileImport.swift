//
//  FileImport.swift
//  Shootaround
//

import Foundation

func readDeck(from url: URL) throws -> String {
    // 1. Start access: url.startAccessingSecurityScopedResource() returns a Bool. Keep it.
    let granted = url.startAccessingSecurityScopedResource()
    // 2. Schedule the stop with defer, only if access was granted.
    defer { if granted { url.stopAccessingSecurityScopedResource() } }
    // 3. Read and return the text: try String(contentsOf:encoding:)
    return try String(contentsOf: url, encoding: .utf8)
}
