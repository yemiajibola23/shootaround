//
//  Deck.swift
//  Shootaround
//
//  Created by Yemi Ajibola on 10/13/26.
//


import SwiftData
import Foundation


enum Deck: String, Codable {
    case aiEngineering = "AI Engineering"
    case ios = "iOS"
    case basketballData = "Basketball Data"
    case behavioral = "Behavioral"
}


enum CardKind: String, Codable {
    case code
    case explain
    case recall
}

enum CardSource: String, Codable {
    case manual
    case jobAssistant
    case generated
}



@Model
final class Card {
    var id: UUID = UUID()
    var deck: Deck
    var concept: String
    var kind: CardKind
    var prompt: String
    var answer: String
    var source: CardSource
    var ease: Double = 2.5
    var intervalDays: Int = 0
    var repetitions: Int  = 0
    var due: Date = Date()

    
    init(deck: Deck, concept: String, kind: CardKind,
         prompt: String, answer: String, source: CardSource) {
        // 3. Assign each parameter to the property with the same name,
        //    using self.property = parameter
        self.deck = deck
        self.concept = concept
        self.kind = kind
        self.prompt = prompt
        self.answer = answer
        self.source = source
        // 4. Don't touch the properties that already have defaults
    }
}
