//
//  CurrentDayWorkoutView.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import _SwiftData_SwiftUI
import SwiftUI

struct CurrentDayWorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var currentPhase: String
    @Binding var currentDay: String
    @Binding var currentWeek: Int
    @Binding var lastCompletedItem: Int
    @State var maxDataChanged: Bool = false

    @State private var dayExercises: [DayExercises] = []

    @State private var selectedItems: Set<String> = []
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var phaseManager: PhaseManager
    let phaseOptions = ["Postseason", "Winter", "Spring", "Summer", "Preseason", "In-Season"]

    func roundToNearestMultipleOfFive(_ number: Double) -> Double {
        let val = 5 * round(Double(number) / 5.0)

        return val
    }

    func listExercisesForDay(in postseason: PostseasonModel, week: Int, dayName: String, context: ModelContext) -> [DayExercises] {
        guard let week = postseason.week.first(where: { $0.name == "\(week)" }),
              let day = week.days.first(where: { $0.name == dayName }),
              let exercises = day.exercises
        else {
//            print("no stuff")
            return []
        }

        var results: [DayExercises] = []

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

                let exercise = DayExercises(text: line.trim(), type: exercise.type, name: exercise.name, sets: sets, max: (savedMaxLift != nil) ? savedMaxLift! : 0.0)

//                print("exercise: \(exercise.id) \(exercise.name) \(exercise.type) \(exercise.sets.count) \(exercise.max)")

                results.append(exercise)
            }
        }

        return results
    }

    func getDayData() {
        do {
            if let url = Bundle.main.url(forResource: currentPhase, withExtension: "json"),
               let data = try? Data(contentsOf: url),
               let postseason = try? JSONDecoder().decode(PostseasonModel.self, from: data)
            {
                print("getDayData currentPhase: \(currentPhase)")
                print("currentWeek: \(currentWeek)")
                print("currentDay: \(currentDay)")

                dayExercises = listExercisesForDay(
                    in: postseason,
                    week: currentWeek,
                    dayName: currentDay,
                    context: modelContext
                )

            } else {
                print("can't get data for \(currentPhase)")
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
            ExercisesListView(currentDay: $currentDay, lastCompletedItem: $lastCompletedItem, exercises: dayExercises, maxDataChanged: $maxDataChanged)
                .onChange(of: lastCompletedItem) { newValue in
                    print("CurrentDayWorkoutView lastCompletedItem changed to: \(newValue)")

                    ModelUtils.savePhase(phaseOptions: phaseOptions, dayExerciseCount: dayExercises.count, lastCompletedItem: &lastCompletedItem, currentPhase: &currentPhase, currentDay: &currentDay, currentWeek: &currentWeek, phaseManager: phaseManager, modelContext: modelContext)
                }
                .onChange(of: maxDataChanged) { newValue in

                    if maxDataChanged {
                        print("maxDataChanged changed to: \(newValue)")
                        getDayData()
                    }

                    maxDataChanged = false
                }
                .onAppear {
//                    print("CurrentDayWorkoutView onAppear")
                }
        }
    }
}

#Preview {
    let schema = Schema([
        Item.self,
        MaxIntensityRecord.self,
        PhaseRecord.self
    ])
    let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: [configuration])

    // 3. Use a context from the model container to create the PhaseManager
    return ModelContextPreview(container: container) { modelContext in
        let phaseManager = PhaseManager(modelContext: modelContext)

        return NavigationStack {
            CurrentDayWorkoutView(currentPhase: .constant("Preseason"), currentDay: .constant("Monday"), currentWeek: .constant(1), lastCompletedItem: .constant(0))
                //        .modelContainer(for: Item.self, inMemory: true)
                .modelContainer(for: MaxIntensityRecord.self)
                .environmentObject(NavigationManager())
                .environmentObject(phaseManager)
        }
    }
    .modelContainer(container)
}
