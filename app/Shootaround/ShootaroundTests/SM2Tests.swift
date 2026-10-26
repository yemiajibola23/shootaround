//
//  SM2Tests.swift
//  Shootaround
//
//  Created by Yemi Ajibola on 10/22/26.
//
import Testing
import Foundation

struct SM2State {
    var ease: Double
    var intervalDays: Int
    var repetitions: Int
}

func calculateEase(oldEase: Double, grade: Int) -> Double {
    let gap = (0.08 + (5 - Double(grade)) * 0.02)
    let easeFormula = (0.1 - (5 - Double(grade)) * gap)
    return oldEase + easeFormula
}

func sm2Update(_ state: SM2State, grade: Int) -> SM2State {
    if grade < 3 { return SM2State(ease: state.ease, intervalDays: 1, repetitions: 0) }

    var newInterval: Int
    switch state.repetitions {
    case 0: newInterval = 1
    case 1: newInterval = 6
    default:
        let oldInterval = Double(state.intervalDays) * state.ease
        newInterval = Int(oldInterval.rounded())
    }

    let newRepetitons = state.repetitions + 1
    let newEase = calculateEase(oldEase: state.ease, grade: grade)
    
    return SM2State(ease: max(newEase, 1.3), intervalDays: newInterval, repetitions: newRepetitons)
}

func dueDate(reviewDate: Date, intervalDays: Int, calendar: Calendar) -> Date {
        return calendar.date(byAdding: .day, value: intervalDays, to: reviewDate)!
}

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
        // 1. Build a Chicago calendar
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/Chicago")!
        // 2. Build a review time shortly after midnight on Oct 31, 2026
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
}
