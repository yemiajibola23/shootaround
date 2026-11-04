//
//  DeckImport.swift
//  Shootaround
//

import SwiftData
import Foundation

func importDeck(_ csv: String, into context: ModelContext) throws -> Int {
    // 1. Parse the csv
    let deckImport = try parseDeck(csv)
    // 2. Fetch what's stored and collect the existing prompts
    var prompts: Set<String> = Set(try context.fetch(FetchDescriptor<Card>()).map { return $0.prompt })
    // 3. Insert only cards whose prompt isn't stored yet
    for card in deckImport {
        if !prompts.contains(card.prompt) {
            context.insert(card)
            prompts.insert(card.prompt)
        }
    }
    // 4. Save, then return the store's card count
    try context.save()
    
    return try context.fetch(FetchDescriptor<Card>()).count
}
