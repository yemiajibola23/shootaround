//
//  DueQueue.swift
//  Shootaround
//

import SwiftData
import Foundation

func dueCardsDescriptor(now: Date, deck: Deck? = nil) -> FetchDescriptor<Card> {
    var predicate: Predicate<Card>
    
    if let unwrappedDeck = deck {
        predicate = #Predicate<Card> { $0.due <= now && $0.deck == unwrappedDeck }
    } else {
        predicate = #Predicate<Card> { $0.due <= now }
    }
    
    return FetchDescriptor(predicate: predicate, sortBy: [SortDescriptor(\Card.due)])
}
