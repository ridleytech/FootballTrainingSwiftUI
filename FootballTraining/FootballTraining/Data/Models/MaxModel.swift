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
class KPIProgress {
    var id: UUID
    var exercise: String
    var weight: Double
    var dateRecorded: Date

    init(weight: Double, exercise: String, dateRecorded: Date = Date()) {
        self.id = UUID()
        self.exercise = exercise
        self.weight = weight
        self.dateRecorded = dateRecorded
    }
}

@Model
class TrainingKPI {
    @Attribute(.unique) var id = UUID()
    var exerciseName: String
    var dateRecorded: Date

    var bodyWeightMultiplierMin: Double?
    var bodyWeightMultiplierMax: Double?

    var repsMin: Int?
    var repsMax: Int?

    var liftSpeedConcentricMin: Double?
    var liftSpeedConcentricMax: Double?
    var liftSpeedEccentric: Double?

    var lengthSecondsMin: Int?
    var lengthSecondsMax: Int?

    var weightRangeDescription: String?
    var notes: String?

    var currentProgress: String?
    var targetGoal: String?

    init(
        exerciseName: String,
        dateRecorded: Date,
        bodyWeightMultiplierMin: Double? = nil,
        bodyWeightMultiplierMax: Double? = nil,
        repsMin: Int? = nil,
        repsMax: Int? = nil,
        liftSpeedConcentricMin: Double? = nil,
        liftSpeedConcentricMax: Double? = nil,
        liftSpeedEccentric: Double? = nil,
        lengthSecondsMin: Int? = nil,
        lengthSecondsMax: Int? = nil,
        weightRangeDescription: String? = nil,
        notes: String? = nil,
        currentProgress: String? = nil,
        targetGoal: String? = nil
    ) {
        self.exerciseName = exerciseName
        self.dateRecorded = dateRecorded
        self.bodyWeightMultiplierMin = bodyWeightMultiplierMin
        self.bodyWeightMultiplierMax = bodyWeightMultiplierMax
        self.repsMin = repsMin
        self.repsMax = repsMax
        self.liftSpeedConcentricMin = liftSpeedConcentricMin
        self.liftSpeedConcentricMax = liftSpeedConcentricMax
        self.liftSpeedEccentric = liftSpeedEccentric
        self.lengthSecondsMin = lengthSecondsMin
        self.lengthSecondsMax = lengthSecondsMax
        self.weightRangeDescription = weightRangeDescription
        self.notes = notes
        self.currentProgress = currentProgress
        self.targetGoal = targetGoal
    }

    // Calculate targetGoal based on the latest weight record and multipliers
    func calculateTargetGoal(weight: Double) -> String {
        var targetGoal = ""

        if bodyWeightMultiplierMin != nil && bodyWeightMultiplierMin != nil {
            let latestWeight = weight
            let minWeight = Utils.roundToNearestMultipleOfFive(latestWeight * bodyWeightMultiplierMin!)
            let maxWeight = Utils.roundToNearestMultipleOfFive(latestWeight * bodyWeightMultiplierMax!)
            targetGoal = String(format: "%.0f - %.0f lbs", minWeight, maxWeight)
        } else {
            targetGoal = "N/A"
        }

        return targetGoal
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
