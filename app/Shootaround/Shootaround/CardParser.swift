//
//  CardParser.swift
//  Shootaround
//
//  Created by Yemi Ajibola on 10/15/26.
//

import Foundation

enum CardRowError: Error, Equatable {
    case wrongColumnCount(Int)
    case badDeck(String)
    case badKind(String)
    case badSource(String)
}

func parseRow(_ row: String) throws -> Card {
    let columns = row.split(separator: ",", omittingEmptySubsequences: false).map(String.init)
    
    guard columns.count == 6 else { throw CardRowError.wrongColumnCount(columns.count) }

    guard let deck = Deck(rawValue: columns[0]) else { throw CardRowError.badDeck(columns[0]) }

    guard let kind = CardKind(rawValue: columns[2]) else { throw CardRowError.badKind(columns[2]) }

    
    guard let source = CardSource(rawValue: columns[5]) else { throw CardRowError.badSource(columns[5]) }

    return Card(deck: deck, concept: columns[1], kind: kind, prompt: columns[3], answer: columns[4], source: source)
}
