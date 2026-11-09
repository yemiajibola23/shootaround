//
//  DeckImport.swift
//  Shootaround
//

import SwiftData
import Foundation

func importDeck(_ csv: String, into context: ModelContext) throws -> Int {
    let deckImport = try parseDeck(csv)
    var prompts: Set<String> = Set(try context.fetch(FetchDescriptor<Card>()).map { return $0.prompt })
    for card in deckImport {
        if !prompts.contains(card.prompt) {
            context.insert(card)
            prompts.insert(card.prompt)
        }
    }

    try context.save()
    
    return try context.fetch(FetchDescriptor<Card>()).count
}
