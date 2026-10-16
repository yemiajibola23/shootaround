import Testing
import Foundation
import SwiftData
 @testable import Shootaround

struct ReviewTests {
    @Test func reviewOptionalFieldsDefaultToNil() {
        // 1. Make a UUID to stand in for the card this review belongs to
        //    (a variable, so you can compare against it later)
        let cardID = UUID()

        // 2. Make a Review with that cardID, reviewedAt: Date(), grade: 4
        //    Do NOT pass typedAnswer or aiScore
        let sut = Review(cardID: cardID, reviewedAt: Date(), grade: 4)

        // 3. #expect the review's cardID equals the UUID from step 1
        #expect(sut.cardID == cardID)

        // 4. #expect the review's grade equals 4
        #expect(sut.grade == 4)

        // 5. #expect typedAnswer == nil
        #expect(sut.typedAnswer == nil)

        // 6. #expect aiScore == nil
        #expect(sut.aiScore == nil)

    }
    
    @Test func reviewStoresOptionalFieldsWhenProvided() {
        let cardiD = UUID()
        let sut = Review(cardID: cardiD, reviewedAt: Date(), grade: 4, typedAnswer: "Hello world", aiScore: 5)
        #expect(sut.typedAnswer == "Hello world")
        #expect(sut.aiScore == 5)
    }
}


