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

    let gap = (0.08 + (5 - Double(grade)) * 0.02)
    let easeFormula = (0.1 - (5 - Double(grade)) * gap)
    let ease =  state.ease + easeFormula
    
    return SM2State(ease: max(ease, 1.3), intervalDays: newInterval, repetitions: newRepetitons)
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
        // 1. Build a state: ease 2.3, interval 4, repetitions 2
        let state = SM2State(ease: 2.3, intervalDays: 4, repetitions: 2)

        // 2. Call sm2Update with grade 4
        let sut = sm2Update(state, grade: 4)

        // 3. #expect intervalDays equals round-to-nearest of 4 * 2.3
        #expect(sut.intervalDays == 9)
        #expect(sut.repetitions == 3)

    }
}
