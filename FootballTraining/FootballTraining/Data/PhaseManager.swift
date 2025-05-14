//
//  PhaseManager.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/27/25.
//

import Foundation
import SwiftData
import SwiftUI

import Foundation
import SwiftData

class PhaseViewModel: ObservableObject {
    @Published var currentPhase: String = "Postseason"
    @Published var currentWeek: Int = 1
    @Published var currentDay: String = "Monday"
    @Published var selectedExercise: DayExercise = .init(text: "String", type: "String", name: "String", sets: [], max: 0.0)
    @Published var lastCompletedItem: Int = 0
    @State var phases = ["Postseason", "Winter", "Spring", "Summer", "Preseason", "In-Season"]
    @Published var weeks = [1, 2, 3, 4, 5, 6, 7]
    @Published var days = ["Monday", "Tuesday", "Thursday", "Friday"]
    @Published var pickingPhase = false
    @Published var maxDataChanged: Bool = false
    @Published var selectedExerciseIndex: Int = 0
    @Published var completedDayExercises: [Int] = []
}

class PhaseManager: ObservableObject {
    @Published var phaseRecord: PhaseRecord?

    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadOrCreatePhaseRecord()
    }

    func getDayData(viewModel: PhaseViewModel) -> [DayExercise] {
        do {
            if let url = Bundle.main.url(forResource: viewModel.currentPhase, withExtension: "json"),
               let data = try? Data(contentsOf: url),
               let postseason = try? JSONDecoder().decode(PostseasonModel.self, from: data)
            {
                print("getDayData currentPhase: \(viewModel.currentPhase)")
                print("currentWeek: \(viewModel.currentWeek)")
                print("currentDay: \(viewModel.currentDay)")

                return PhaseManager.listExercisesForDay(
                    in: postseason,
                    week: viewModel.currentWeek,
                    dayName: viewModel.currentDay,
                    context: modelContext
                )

            } else {
                print("can't get data for \(viewModel.currentPhase)")

                return []
            }

        } catch {
            print("Failed to fetch all records:", error)

            return []
        }
    }

    static func listExercisesForDay(in postseason: PostseasonModel, week: Int, dayName: String, context: ModelContext) -> [DayExercise] {
        guard let week = postseason.week.first(where: { $0.name == "\(week)" }),
              let day = week.days.first(where: { $0.name == dayName }),
              let exercises = day.exercises
        else {
//            print("no stuff")
            return []
        }

        var results: [DayExercise] = []

        for exercise in exercises {
            var line = "" // "\(exercise.name):"

            // Try to fetch the max lift saved in SwiftData
            let descriptor = FetchDescriptor<MaxIntensityRecord>(predicate: #Predicate { $0.exerciseName == exercise.name })
            let savedMaxLift = (try? context.fetch(descriptor).first?.maxIntensity)

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

//                self.id = id
//                self.text = text
//                self.type = type
//                self.name = name
//                self.sets = sets
//                self.max = max

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
                let new = PhaseRecord(phaseName: "Postseason", phaseWeek: 1, phaseDay: "Monday", lastCompletedItem: 0, phaseWeekTotal: 5)
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
