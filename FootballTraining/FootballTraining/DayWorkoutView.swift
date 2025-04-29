//
//  DayWorkoutView.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import _SwiftData_SwiftUI
import SwiftUI

struct DayWorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var currentPhase: String
    @Binding var currentDay: String
    @Binding var currentWeek: Int
    @Binding var lastCompletedItem: Int

    @State private var dayExercises: [(text: String, type: String, name: String, sets: [SetElement], max: Double)] = []
    @State private var completedExercises: [(text: String, type: String, name: String, sets: [SetElement], max: Double)] = []
    @State private var selectedItems: Set<String> = []
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var phaseManager: PhaseManager

    func roundToNearestMultipleOfFive(_ number: Double) -> Double {
//        print("number: \(number)")

        let val = 5 * round(Double(number) / 5.0)

//        print("rounded: \(val)")
        return val
    }

    func listExercisesForDay(in postseason: PostseasonModel, weekName: Int, dayName: String, context: ModelContext) -> [(text: String, type: String, name: String, sets: [SetElement], max: Double)] {
        guard let week = postseason.week.first(where: { $0.name == "\(weekName)" }),
              let day = week.days.first(where: { $0.name == dayName }),
              let exercises = day.exercises
        else {
            return []
        }

        var results: [(text: String, type: String, name: String, sets: [SetElement], max: Double)] = []

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
                            let formattedLift = String(format: "%.0f", roundToNearestMultipleOfFive(calculatedLift)) // no decimals
                            line += " \(formattedLift) x \(reps)"
                        } else {
                            // fallback to showing raw intensity
                            line += " \(intensityString) x \(reps)"
                        }
                    }
                }

                results.append((text: line.trim(), type: exercise.type, name: exercise.name, sets: sets, max: (savedMaxLift != nil) ? savedMaxLift! : 0.0))
            }
        }

        return results
    }

    func savePhase() {
        print("savePhase DayWorkoutView")

        do {
            phaseManager.update(phaseName: currentPhase, phaseWeek: currentWeek, phaseDay: currentDay, lastCompletedItem: lastCompletedItem)

            print("Phase: \(phaseManager.phaseRecord?.phaseName)")

            var descriptor = FetchDescriptor<PhaseRecord>(
                predicate: #Predicate { $0.phaseName == currentPhase }
            )
            descriptor.fetchLimit = 1 // set fetchLimit separately

            let existingRecords = try modelContext.fetch(descriptor)

            if let existingRecord = existingRecords.first {
                existingRecord.phaseWeek = currentWeek
                existingRecord.phaseDay = currentDay
                existingRecord.phaseName = currentPhase
                existingRecord.lastCompletedItem = lastCompletedItem
                print("Updated \(currentPhase) with week \(currentWeek) and day \(currentDay) and lastCompletedItem \(lastCompletedItem)")

                currentPhase = existingRecord.phaseName
                currentWeek = existingRecord.phaseWeek
                currentDay = existingRecord.phaseDay
                lastCompletedItem = existingRecord.lastCompletedItem
            } else {
                let newRecord = PhaseRecord(phaseName: currentPhase, phaseWeek: currentWeek, phaseDay: currentDay, lastCompletedItem: lastCompletedItem)
                modelContext.insert(newRecord)
                print("Saved new \(currentPhase) with week \(currentWeek) and day \(currentDay) and lastCompletedItem \(lastCompletedItem)")
            }

            try modelContext.save()

        } catch {
            print("Failed to fetch or save phase:", error)
        }
    }

    func getDayData() {
//        print("getDayData")
//
//        print("currentPhase: \(currentPhase)")
//        print("currentWeek: \(currentWeek)")
//        print("currentDay: \(currentDay)")

        do {
            if let url = Bundle.main.url(forResource: currentPhase, withExtension: "json"),
               let data = try? Data(contentsOf: url),
               let postseason = try? JSONDecoder().decode(PostseasonModel.self, from: data)
            {
                dayExercises = listExercisesForDay(
                    in: postseason,
                    weekName: currentWeek,
                    dayName: currentDay,
                    context: modelContext
                )
//
//                print("dayExercises: \(dayExercises)")
            }

        } catch {
            print("Failed to fetch all records:", error)
        }
    }

    var body: some View {
        if dayExercises.isEmpty {
            ProgressView("Loading...")
                .onAppear {
                    getDayData()
                }

        } else {
            ExercisesView(currentDay: $currentDay, exercises: dayExercises, completedExercises: $completedExercises, lastCompletedItem: $lastCompletedItem)
                .onChange(of: lastCompletedItem) { newValue in
                    print("lastCompletedItem changed to: \(newValue)")

                    savePhase()

                    // to do. check if last week in phase, if so, advance to next phase
                    // check if last exercise in day, if so, advance to next day
                }
                .onAppear {
//                    savePhase()
                    print("DayWorkoutView lastCompletedItem: \(lastCompletedItem)")
                }
        }
    }
}

// #Preview {
//    let phaseManager = PhaseManager(
//        phaseRecord: PhaseRecord(phaseName: "Postseason", phaseWeek: 1, phaseDay: "Monday", lastCompletedItem: 0)
//    )
//
//    NavigationStack {
//        DayWorkoutView(currentPhase: .constant("Preseason"), currentDay: .constant("Monday"), currentWeek: .constant(1), lastCompletedItem: .constant(0))
//            //        .modelContainer(for: Item.self, inMemory: true)
//            .modelContainer(for: MaxIntensityRecord.self)
//            .environmentObject(NavigationManager())
//            .environmentObject(phaseManager)
//    }
// }
