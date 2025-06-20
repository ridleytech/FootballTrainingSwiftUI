//
//  PhaseModel.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import Foundation
import SwiftData
import SwiftUI

class PhaseModel: Codable, Hashable {
    var name: String
    var week: [Week]

    static func == (lhs: PhaseModel, rhs: PhaseModel) -> Bool {
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
