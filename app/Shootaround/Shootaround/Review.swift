//
//  Review.swift
//  Shootaround
//
//  Created by Yemi Ajibola on 10/15/26.
//

import Foundation
import SwiftData


@Model
final class Review {
    var cardID: UUID
    var reviewedAt: Date
    var grade: Int
    var typedAnswer: String?
    var aiScore: Int?
    var id = UUID()

    init(cardID: UUID, reviewedAt: Date, grade: Int, typedAnswer: String? = nil, aiScore: Int? = nil) {
        self.cardID = cardID
        self.reviewedAt = reviewedAt
        self.grade = grade
        self.typedAnswer = typedAnswer
        self.aiScore = aiScore
    }

}
