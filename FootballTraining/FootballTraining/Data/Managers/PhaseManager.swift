//
//  PhaseManager.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/27/25.
//

import Foundation
import SwiftData
import SwiftUI

class PhaseViewModel: ObservableObject {
    @Published var currentPhase: String = "Postseason"
    @Published var currentWeek: Int = 1
    @Published var currentDay: String = "Monday"
    @Published var selectedExercise: DayExercise = .init(text: "String", type: "String", name: "String", sets: [], max: 0.0)
    @Published var lastCompletedItem: Int = 0
    @Published var lastSprintCompletedItem: Int = 0
    @Published var lastConditioningCompletedItem: Int = 0
    @State var phases = ["Postseason", "Winter", "Spring", "Summer", "Preseason", "In-Season"]
    @Published var weeks = [1, 2, 3, 4, 5, 6, 7]
    @Published var days = ["Monday", "Tuesday", "Thursday", "Friday"]
    @Published var pickingPhase = false
    @Published var maxDataChanged: Bool = false
    @Published var selectedExerciseIndex: Int = 0
    @Published var completedDayExercises: [Int] = []
    @Published var selectedKPI: TrainingKPI = .init(exerciseName: "", dateRecorded: Date())
}

class PhaseManager: ObservableObject {
    @Published var phaseRecord: PhaseRecord?

    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadOrCreatePhaseRecord()
    }

    func getDayData(viewModel: PhaseViewModel) -> ([DayExercise], [DayExercise], [ConditioningExercise]) {
        var weightExercises: [DayExercise] = []
        var accelerationExercises: [DayExercise] = []
        var conditioningExercises: [ConditioningExercise] = []

        do {
            // Load primary phase JSON (e.g., weights)
            if let url = Bundle.main.url(forResource: viewModel.currentPhase, withExtension: "json"),
               let data = try? Data(contentsOf: url),
               let phaseData = try? JSONDecoder().decode(PhaseModel.self, from: data)
            {
                let primary = PhaseManager.listExercisesForDay(
                    in: phaseData,
                    week: viewModel.currentWeek,
                    dayName: viewModel.currentDay,
                    context: modelContext
                )

                weightExercises.append(contentsOf: primary)
            }

            // Load acceleration phase JSON
            if let accUrl = Bundle.main.url(forResource: "Acceleration", withExtension: "json"),
               let accData = try? Data(contentsOf: accUrl),
               let accPhase = try? JSONDecoder().decode(PhaseModel.self, from: accData)
            {
//                let accel = PhaseManager.listExercisesForDay(
//                    in: accPhase,
//                    week: viewModel.currentWeek,
//                    dayName: viewModel.currentDay,
//                    context: modelContext
//                )

                let (accel, conditioning) = PhaseManager.listExercisesForDay2(
                    in: accPhase,
                    week: viewModel.currentWeek,
                    dayName: viewModel.currentDay,
                    context: modelContext
                )

                print("accel PM: \(accel)")
                print("conditioning PM: \(conditioning)")

                conditioningExercises.append(contentsOf: conditioning)
                accelerationExercises.append(contentsOf: accel)
            }

        } catch {
            print("Error decoding day data: \(error)")
        }

        return (weightExercises, accelerationExercises, conditioningExercises)
    }

    static func listExercisesForDay2(
        in postseason: PhaseModel,
        week: Int,
        dayName: String,
        context: ModelContext
    ) -> ([DayExercise], [ConditioningExercise]) {
        guard let week = postseason.week.last(where: { $0.name == "\(week)" }),
              let day = week.days.first(where: { $0.name == dayName })
        else {
            print("no stuff")
            return ([], [])
        }

        var results: [DayExercise] = []
        var conditioningResults: [ConditioningExercise] = []

        // Handle main exercises
        if let exercises = day.exercises {
            for exercise in exercises {
                var line = ""

                // Fetch max lift
                let descriptor = FetchDescriptor<MaxIntensityRecord>(
                    predicate: #Predicate { $0.exerciseName == exercise.name }
                )
                let savedMaxLift = (try? context.fetch(descriptor).first?.maxIntensity)

                if let sets = exercise.sets {
                    for set in sets {
                        if let intensityString = set.intensity, let reps = set.reps {
                            if let intensity = Double(intensityString), let maxLift = savedMaxLift {
                                let calculatedLift = intensity * maxLift
                                let formattedLift = String(format: "%.0f", Utils.roundToNearestMultipleOfFive(calculatedLift))
                                line += " \(formattedLift) x \(reps)"
                            } else {
                                line += " \(intensityString) x \(reps)"
                            }
                        }
                    }

                    let exercise = DayExercise(
                        text: line.trim(),
                        type: exercise.type,
                        name: exercise.name,
                        sets: sets,
                        max: savedMaxLift ?? 0.0
                    )

                    results.append(exercise)
                }
            }
        }

        // Handle conditioning (pull all conditioning blocks & exercises)
        if let conditioningBlocks = day.conditioning {
            for block in conditioningBlocks {
                conditioningResults.append(contentsOf: block.exercise)
            }
        }

        return (results, conditioningResults)
    }

    static func listExercisesForDay(in postseason: PhaseModel, week: Int, dayName: String, context: ModelContext) -> [DayExercise] {
        guard let week = postseason.week.first(where: { $0.name == "\(week)" }),
              let day = week.days.first(where: { $0.name == dayName }),
              let exercises = day.exercises
        else {
            print("no stuff")
            return []
        }

        var results: [DayExercise] = []

        for exercise in exercises {
            var line = "" // "\(exercise.name):"

            // Try to fetch the max lift saved in SwiftData
            let descriptor = FetchDescriptor<MaxIntensityRecord>(predicate: #Predicate { $0.exerciseName == exercise.name })
            let savedMaxLift = (try? context.fetch(descriptor).last?.maxIntensity)

//            print("savedMaxLift \(exercise.name): \(savedMaxLift)")

            if let sets = exercise.sets {
                for set in sets {
                    if let intensityString = set.intensity, let reps = set.reps {
                        if let intensity = Double(intensityString), let maxLift = savedMaxLift {
                            // Calculate real lift amount
                            let calculatedLift = intensity * maxLift
                            let formattedLift = String(format: "%.0f", Utils.roundToNearestMultipleOfFive(calculatedLift)) // no decimals
                            line += " \(formattedLift) x \(reps)"
                        } else {
                            // fallback to showing raw intensity
                            line += " \(intensityString) x \(reps)"
                        }
                    }
                }

                let exercise = FootballTraining.DayExercise(text: line.trim(), type: exercise.type, name: exercise.name, sets: sets, max: (savedMaxLift != nil) ? savedMaxLift! : 0.0)

//                print("exercise: \(exercise.id) \(exercise.name) \(exercise.type) \(exercise.sets.count) \(exercise.max)")

                results.append(exercise)
            }
        }

        return results
    }

    func loadOrCreatePhaseRecord() {
        do {
            var descriptor = FetchDescriptor<PhaseRecord>()
            descriptor.fetchLimit = 1

            let records = try modelContext.fetch(descriptor)

            if let existing = records.first {
                phaseRecord = existing
//                print("Loaded existing PhaseRecord: \(existing.description)")
            } else {
                let new = PhaseRecord(phaseName: "Postseason", phaseWeek: 1, phaseDay: "Monday", lastCompletedItem: 0, phaseWeekTotal: 6)
                modelContext.insert(new)
                try modelContext.save()
                phaseRecord = new
                print("Created new PhaseRecord")
            }

        } catch {
            print("Failed to load or create PhaseRecord:", error)
        }
    }

    func update(phaseName: String, phaseWeek: Int, phaseDay: String, lastCompletedItem: Int, phaseWeekTotal: Int) {
        guard let record = phaseRecord else { return }

        record.phaseName = phaseName
        record.phaseWeek = phaseWeek
        record.phaseDay = phaseDay
        record.lastCompletedItem = lastCompletedItem
        record.phaseWeekTotal = phaseWeekTotal

        do {
            try modelContext.save()
            print("Updated PhaseRecord: \(record.description)")
        } catch {
            print("Failed to update PhaseRecord:", error)
        }
    }
}
