//
//  DueQueue.swift
//  Shootaround
//

import SwiftData
import Foundation

func dueCardsDescriptor(now: Date) -> FetchDescriptor<Card> {
    let predicate = #Predicate<Card> { $0.due <= now }

    return FetchDescriptor(predicate: predicate, sortBy: [SortDescriptor(\Card.due)])
}
