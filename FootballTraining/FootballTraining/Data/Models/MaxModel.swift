//
//  MaxModel.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class WeightRecord {
    var id: UUID
    var weight: Double
    var dateRecorded: Date

    init(weight: Double, dateRecorded: Date = Date()) {
        self.id = UUID()
        self.weight = weight
        self.dateRecorded = dateRecorded
    }
}

@Model
class MaxIntensityRecord {
    var exerciseName: String
    var maxIntensity: Double
    var dateRecorded: Date

    init(exerciseName: String, maxIntensity: Double, dateRecorded: Date = Date()) {
        self.exerciseName = exerciseName
        self.maxIntensity = maxIntensity
        self.dateRecorded = dateRecorded
    }
}

@Model
class PhaseRecord {
    var phaseName: String
    var phaseWeek: Int
    var phaseDay: String
    var phaseWeekTotal: Int
    var completedDayExercises: [String]
    var completedDayConditioningExercises: [String]
    var completedDayAccelerationExercises: [String]

    init(phaseName: String, phaseWeek: Int, phaseDay: String, phaseWeekTotal: Int, completedDayExercises: [String], completedDayConditioningExercises: [String], completedDayAccelerationExercises: [String]) {
        self.phaseName = phaseName
        self.phaseWeek = phaseWeek
        self.phaseDay = phaseDay
        self.phaseWeekTotal = phaseWeekTotal
        self.completedDayExercises = completedDayExercises
        self.completedDayConditioningExercises = completedDayConditioningExercises
        self.completedDayAccelerationExercises = completedDayAccelerationExercises
    }

    var description: String {
        return """
        PhaseRecord:
        - Name: \(phaseName)
        - Week: \(phaseWeek)
        - Day: \(phaseDay)
        - Week Total: \(phaseWeekTotal)
        - completedDayExercises: \(completedDayExercises)
        - completedDayConditioningExercises: \(completedDayConditioningExercises)
        - completedDayAccelerationExercises: \(completedDayAccelerationExercises)
        """
    }
}

struct ModelContextPreview<Content: View>: View {
    let container: ModelContainer
    @State private var isReady = false
    @State private var modelContext: ModelContext? = nil
    let content: (ModelContext) -> Content

    var body: some View {
        ZStack {
            if let modelContext {
                content(modelContext)
            } else {
                Color.clear.onAppear {
                    modelContext = container.mainContext
                }
            }
        }
    }
}
