//
//  Persistence.swift
//  Shootaround
//

import SwiftData
import Foundation

func makeContainer(storeURL: URL?) throws -> ModelContainer {
    guard let url = storeURL else { return try ModelContainer(for: Card.self, configurations: ModelConfiguration()) }

    let config = ModelConfiguration(url: url)

    return try ModelContainer(for: Card.self, configurations: config)
}
