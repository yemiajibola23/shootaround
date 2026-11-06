//
//  FileImport.swift
//  Shootaround
//

import Foundation

func readDeck(from url: URL) throws -> String {
    let granted = url.startAccessingSecurityScopedResource()
    defer { if granted { url.stopAccessingSecurityScopedResource() } }

    return try String(contentsOf: url, encoding: .utf8)
}
