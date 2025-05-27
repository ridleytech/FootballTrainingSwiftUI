//
//  PostseasonModel.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import Foundation
import SwiftUI

class DayExercise: Codable, Hashable, Identifiable {
    let id: UUID
    var text: String
    var type: String
    var name: String
    var sets: [SetElement]
    var max: Double

    init(text: String, type: String, name: String, sets: [SetElement], max: Double, id: UUID = UUID()) {
        self.id = id
        self.text = text
        self.type = type
        self.name = name
        self.sets = sets
        self.max = max
    }

    static func == (lhs: DayExercise, rhs: DayExercise) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class PostseasonModel: Codable, Hashable {
    var name: String
    var week: [Week]

    static func == (lhs: PostseasonModel, rhs: PostseasonModel) -> Bool {
        lhs.name == rhs.name && lhs.week == rhs.week
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(week)
    }
}

class Week: Codable, Hashable {
    var name: String
    var yearweek: String
    var days: [Day]
    var rests: [Rest]

    static func == (lhs: Week, rhs: Week) -> Bool {
        lhs.name == rhs.name && lhs.yearweek == rhs.yearweek && lhs.days == rhs.days && lhs.rests == rhs.rests
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(yearweek)
        hasher.combine(days)
        hasher.combine(rests)
    }
}

class Day: Codable, Hashable {
    var name: String
    var exercises: [Exercise]?
    var conditioning: [Conditioning]?

    static func == (lhs: Day, rhs: Day) -> Bool {
        lhs.name == rhs.name && lhs.exercises == rhs.exercises && lhs.conditioning == rhs.conditioning
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(exercises)
        hasher.combine(conditioning)
    }
}

class Exercise: Codable, Hashable {
    var name: String
    var type: String
    var sets: [SetElement]?

    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        lhs.name == rhs.name && lhs.type == rhs.type && lhs.sets == rhs.sets
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(type)
        hasher.combine(sets)
    }
}

class SetElement: Codable, Hashable {
    var name: String
    var intensity: String?
    var reps: String?
    var time: String?
    var rest: String?

    init(name: String, intensity: String? = nil, reps: String? = nil, time: String? = nil, rest: String? = nil) {
        self.name = name
        self.intensity = intensity
        self.reps = reps
        self.time = time
        self.rest = rest
    }

    static func == (lhs: SetElement, rhs: SetElement) -> Bool {
        lhs.name == rhs.name && lhs.intensity == rhs.intensity && lhs.reps == rhs.reps && lhs.time == rhs.time && lhs.rest == rhs.rest
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(intensity)
        hasher.combine(reps)
        hasher.combine(time)
        hasher.combine(rest)
    }

    var description: String {
        return """
        PhaseRecord:
        - Name: \(name)
        - Intensity: \(String(describing: intensity))
        - Reps: \(String(describing: reps))
        - Time: \(String(describing: time))
        - Rest: \(String(describing: rest))
        """
    }
}

class Rest: Codable, Hashable {
    var name: String
    var time: String

    static func == (lhs: Rest, rhs: Rest) -> Bool {
        lhs.name == rhs.name && lhs.time == rhs.time
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(time)
    }
}

class Conditioning: Codable, Hashable {
    var name: String
    var exercise: [ConditioningExercise]

    static func == (lhs: Conditioning, rhs: Conditioning) -> Bool {
        lhs.name == rhs.name && lhs.exercise == rhs.exercise
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(exercise)
    }
}

class ConditioningExercise: Codable, Hashable {
    var name: String
    var type: String
    var sets: [SetElement]

    static func == (lhs: ConditioningExercise, rhs: ConditioningExercise) -> Bool {
        lhs.name == rhs.name && lhs.type == rhs.type && lhs.sets == rhs.sets
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(type)
        hasher.combine(sets)
    }
}
