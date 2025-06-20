//
//  Conditioning.swift
//  FootballTraining
//
//  Created by Randall Ridley on 6/18/25.
//

import Foundation
import SwiftData

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
