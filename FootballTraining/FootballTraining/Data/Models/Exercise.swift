//
//  Exercise.swift
//  FootballTraining
//
//  Created by Randall Ridley on 6/18/25.
//

import Foundation
import SwiftData

class DayExercise: Codable, Hashable, Identifiable {
    let id: UUID
    var text: String
    var type: String
    var name: String
    var sets: [SetElement]
    var max: Double
    var trainingType: TrainingType?

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

    var description: String {
        return """
        PhaseRecord:
        - Name: \(name)
        - ID: \(String(describing: id))
        - text: \(String(describing: text))
        - max: \(String(describing: max))
        """
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

@Model
class SkippedExercises {
    var id: UUID
    var exercises: [DayExercise]
    var date: Date
    var day: String
    var week: Int

    init(exercises: [DayExercise], id: UUID = UUID(), date: Date, day: String, week: Int) {
        self.id = id
        self.exercises = exercises
        self.day = day
        self.week = week
        self.date = date
    }
}

enum TrainingType: String, Codable {
    case acceleration
    case conditioning
    case weight
}
