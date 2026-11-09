//
//  Persistence.swift
//  Shootaround
//

import SwiftData
import Foundation

func makeContainer(storeURL: URL?) throws -> ModelContainer {
    let schema = Schema(Card.self, Review.self)
    guard let url = storeURL else { return try ModelContainer(for: schema, configurations: ModelConfiguration()) }

    let config = ModelConfiguration(url: url)

    return try ModelContainer(for: schema, configurations: config)
}
