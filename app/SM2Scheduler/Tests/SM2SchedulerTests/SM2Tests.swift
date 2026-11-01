//
//  SM2Tests.swift
//  Shootaround
//
//  Created by Yemi Ajibola on 10/22/26.
//
import Testing
import Foundation
@testable import SM2Scheduler

struct SM2Tests {
    @Test func firstPassSetsOneDayInterval() {
        let sut = SM2State(ease: 2.5, intervalDays: 0, repetitions: 0)
        
        let res = sm2Update(sut, grade: 4)

        #expect(res.intervalDays == 1)
        #expect(res.ease == 2.5)
        #expect(res.repetitions == 1)
    }
    
    @Test func easeNeverDropsBelowFloor() {
        let state = SM2State(ease: 1.3, intervalDays: 6, repetitions: 2)
        
        let sut = sm2Update(state, grade: 3)

        #expect(sut.ease == 1.3)
    }
    
    @Test func failRestartsScheduleKeepsEase() {
        // 1. Build a state: ease 2.7, interval 16, repetitions 3
        let state = SM2State(ease: 2.7, intervalDays: 16, repetitions: 3)
        // 2. Call sm2Update with grade 2
        let sut = sm2Update(state, grade: 2)
        // 3. #expect repetitions, intervalDays and ease
        #expect(sut.repetitions == 0)
        #expect(sut.intervalDays == 1)
        #expect(sut.ease == 2.7)
    }
    
    @Test func thirdPassMultipliesIntervalByEase() {
        let state = SM2State(ease: 2.6, intervalDays: 6, repetitions: 2)

        let sut = sm2Update(state, grade: 4)

        #expect(sut.intervalDays == 16)
        #expect(sut.repetitions == 3)
    }
    
    @Test func intervalRoundsToNearest() {
        let state = SM2State(ease: 2.3, intervalDays: 4, repetitions: 2)

        let sut = sm2Update(state, grade: 4)

        #expect(sut.intervalDays == 9)
        #expect(sut.repetitions == 3)
    }
    
    @Test func secondPassSetsSixDayInterval() {
        let state = SM2State(ease: 2.5, intervalDays: 1, repetitions: 1)
        
        let sut = sm2Update(state, grade: 4)
        
        #expect(sut.intervalDays == 6)
        #expect(sut.repetitions == 2)
    }
    
    @Test func dueDateCrossesFallBack() {

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/Chicago")!

        var components = DateComponents()
        components.year = 2026
        components.month = 10
        components.day = 31
        components.hour = 0
        components.minute = 2
        
        let octoberDate = calendar.date(from: components)
        let sut = dueDate(reviewDate: octoberDate!, intervalDays: 2, calendar: calendar)
        
        #expect(calendar.component(.day, from: sut) == 2)
    }
    
    @Test func gradeThreeStillCountsAsPass() {
        let state = SM2State(ease: 2.5, intervalDays: 6, repetitions: 2)
        let sut = sm2Update(state, grade: 3)
        #expect(sut.intervalDays == 15)
        #expect(abs(sut.ease - 2.36) < 0.0001)
    }
    
    @Test func gradeFiveRaisesEase() {
        let state = SM2State(ease: 2.5, intervalDays: 6, repetitions: 2)

        let sut = sm2Update(state, grade: 5)
                
        #expect(abs(sut.ease - (2.5 + 0.1)) < 0.0001)
        #expect(sut.intervalDays == Int(round(6 * 2.5)))
        #expect(sut.repetitions == 3)
    }
    
    @Test func dueDateAddsTheGivenInterval() {
        // 1. Build a Chicago calendar and a fixed review date
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/Chicago")!
        
        var components = DateComponents()
        components.year = 2026
        components.month = 11
        components.day = 24
        components.hour = 14
        components.minute = 0
        let novemberDate = calendar.date(from: components)!
        
        let sut = dueDate(reviewDate: novemberDate, intervalDays: 7, calendar: calendar)
        
        #expect(calendar.component(.month, from: sut) == 12)
        #expect(calendar.component(.day, from: sut) == 1)
    }
    
}
