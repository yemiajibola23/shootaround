//
//  ReviewSession.swift
//  Shootaround
//

import SwiftData
import Foundation
import Observation
import SM2Scheduler

@Observable final class ReviewSession {
    var cards: [Card]
    var isRevealed = false
    var currentIndex = 0
    let context: ModelContext

    init(cards: [Card], context: ModelContext) {
        self.cards = cards
        self.context = context
    }
    
    var currentCard: Card? {
        if cards.indices.contains(currentIndex) { return cards[currentIndex] }

        return nil
    }

    func reveal() { isRevealed = true }
 
    func grade(_ value: Int, typedAnswer: String? = nil, now: Date, calendar: Calendar = .current) {
        guard isRevealed, cards.indices.contains(currentIndex) else { return }

        let card = cards[currentIndex]
        let state = sm2Update(SM2State(card: cards[currentIndex]), grade: value)

        card.ease = state.ease
        card.intervalDays = state.intervalDays
        card.repetitions = state.repetitions
        card.due = dueDate(reviewDate: now, intervalDays: card.intervalDays, calendar: calendar)

        let review = Review(cardID: card.id, reviewedAt: now, grade: value, typedAnswer: typedAnswer, aiScore: nil)
        context.insert(review)

        // I chose do/catch to capture the error to display to the user.
        do {
            try context.save()
        } catch {
            print(error)
        }
        currentIndex += 1
        isRevealed = false
    }
}

extension SM2State {
    init(card: Card) {
        self.init(ease: card.ease, intervalDays: card.intervalDays, repetitions: card.repetitions)
    }
}
