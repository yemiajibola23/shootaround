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
