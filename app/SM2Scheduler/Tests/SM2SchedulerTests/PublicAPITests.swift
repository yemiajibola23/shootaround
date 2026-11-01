//
//  PublicAPITests.swift
//  SM2Scheduler
//
//  Created by Yemi Ajibola on 10/31/26.
//


import Testing
import SM2Scheduler
import Foundation

struct PublicAPITests {
    @Test func appCanUpdateAState() {
        let state = SM2State(ease: 2.5, intervalDays: 1, repetitions: 1)
        let sut = sm2Update(state, grade: 4)

        #expect(sut.intervalDays == 6)
    }
    
    @Test func appCanComputeADueDate() {
       
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/Chicago")!

        var components = DateComponents()
        components.year = 2026
        components.month = 10
        components.day = 31
        components.hour = 0
        components.minute = 2
        
        let octoberDate = calendar.date(from: components)
        let sut = dueDate(reviewDate: octoberDate!, intervalDays: 6, calendar: calendar)
    
        #expect(calendar.component(.month, from: sut) == 11)
        #expect(calendar.component(.day, from: sut) == 6)

    }
}
