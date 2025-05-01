//
//  PostseasonModelSwift.swift
//  FootballTraining
//
//  Created by Randall Ridley on 5/1/25.
//

import Foundation
import SwiftData

//  PostseasonModel.swift
//  FootballTraining
//  SwiftData-compatible version

// @Model
// class PostseasonModelSwift {
//    var name: String
//    @Relationship var week: [Week]
//
//    init(name: String, week: [Week]) {
//        self.name = name
//        self.week = week
//    }
// }
//
// @Model
// class Week {
//    var name: String
//    var yearweek: String
//    @Relationship var days: [Day]
//    @Relationship var rests: [Rest]
//
//    init(name: String, yearweek: String, days: [Day], rests: [Rest]) {
//        self.name = name
//        self.yearweek = yearweek
//        self.days = days
//        self.rests = rests
//    }
// }
//
// @Model
// class Day {
//    var name: String
//    @Relationship var exercises: [Exercise]?
//    @Relationship var conditioning: [Conditioning]?
//
//    init(name: String, exercises: [Exercise]? = nil, conditioning: [Conditioning]? = nil) {
//        self.name = name
//        self.exercises = exercises
//        self.conditioning = conditioning
//    }
// }
//
// @Model
// class Exercise {
//    var name: String
//    var type: String
//    @Relationship var sets: [SetElement]?
//
//    init(name: String, type: String, sets: [SetElement]? = nil) {
//        self.name = name
//        self.type = type
//        self.sets = sets
//    }
// }
//
// @Model
// class SetElement {
//    var name: String
//    var intensity: String?
//    var reps: String?
//    var time: String?
//    var rest: String?
//
//    init(name: String, intensity: String? = nil, reps: String? = nil, time: String? = nil, rest: String? = nil) {
//        self.name = name
//        self.intensity = intensity
//        self.reps = reps
//        self.time = time
//        self.rest = rest
//    }
// }
//
// @Model
// class Rest {
//    var name: String
//    var time: String
//
//    init(name: String, time: String) {
//        self.name = name
//        self.time = time
//    }
// }
//
// @Model
// class Conditioning {
//    var name: String
//    @Relationship var exercise: [ConditioningExercise]
//
//    init(name: String, exercise: [ConditioningExercise]) {
//        self.name = name
//        self.exercise = exercise
//    }
// }
//
// @Model
// class ConditioningExercise {
//    var name: String
//    var type: String
//    @Relationship var sets: [SetElement]
//
//    init(name: String, type: String, sets: [SetElement]) {
//        self.name = name
//        self.type = type
//        self.sets = sets
//    }
// }
