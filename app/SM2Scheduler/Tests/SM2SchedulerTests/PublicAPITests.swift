//
//  PublicAPITests.swift
//  SM2Scheduler
//
//  Created by Yemi Ajibola on 10/31/26.
//


import Testing
import SM2Scheduler 

struct PublicAPITests {
    @Test func appCanUpdateAState() {
        let state = SM2State(ease: 2.5, intervalDays: 1, repetitions: 1)
        let sut = sm2Update(state, grade: 4)

        #expect(sut.intervalDays == 6)
    }
}
