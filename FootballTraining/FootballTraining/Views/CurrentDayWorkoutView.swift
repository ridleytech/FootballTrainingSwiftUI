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
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var phaseManager: PhaseManager
    @EnvironmentObject var viewModel: PhaseViewModel

//    @State private var dayExerciseList: [DayExercise] = []
    @State private var weightExercises: [DayExercise] = []
    @State private var accelerationExercises: [DayExercise] = []
    @State private var conditioningExercises: [ConditioningExercise] = []

    @State private var selectedItems: Set<String> = []
    @State var gotData: Bool = false

    let phaseOptions = ["Postseason", "Winter", "Spring", "Summer", "Preseason", "In-Season"]

    var body: some View {
        if weightExercises.isEmpty && !gotData {
            ProgressView("Loading...")
                .onAppear {
                    let (weights, sprints, conditioning) = phaseManager.getDayData(viewModel: viewModel)
                    weightExercises = weights
                    accelerationExercises = sprints
                    conditioningExercises = conditioning

                    print("cdwv weightExercises: \(weightExercises)")
                    print("cdwv conditioningExercises: \(conditioningExercises)")

                    gotData = true

//                    dayExerciseList = phaseManager.getDayData(viewModel: viewModel)
                }
        }
        else if weightExercises.isEmpty && gotData {
            Text("Off week")
        }
        else {
            let convertedConditioning: [DayExercise] = conditioningExercises.map { cond in
                DayExercise(
                    text: cond.sets.map { set in
                        if let reps = set.reps {
                            return "\(reps) reps"
                        }
                        else {
                            return ""
                        }
                    }.joined(separator: ", "),
                    type: cond.type,
                    name: cond.name,
                    sets: cond.sets,
                    max: 0.0
                )
            }

            ExercisesListView(weightExercises: weightExercises, accelerationExercises: accelerationExercises, conditioningExercises: convertedConditioning
//                dayExerciseList: dayExerciseList
            )
            .onChange(of: viewModel.lastCompletedItem) { newValue in
                print("CurrentDayWorkoutView lastCompletedItem changed to: \(newValue)")

                ModelUtils.savePhase(phaseOptions: phaseOptions, dayExerciseCount: weightExercises.count + accelerationExercises.count, lastCompletedItem: &viewModel.lastCompletedItem, currentPhase: &viewModel.currentPhase, currentDay: &viewModel.currentDay, currentWeek: &viewModel.currentWeek, phaseManager: phaseManager, modelContext: modelContext)

                if viewModel.lastCompletedItem == 0 {
                    let (weights, sprints, conditioning) = phaseManager.getDayData(viewModel: viewModel)
                    weightExercises = weights
                    accelerationExercises = sprints
                    conditioningExercises = conditioning

//                    dayExerciseList = phaseManager.getDayData(viewModel: viewModel)
                }
            }
            .onChange(of: viewModel.maxDataChanged) { newValue in

                if viewModel.maxDataChanged {
                    print("maxDataChanged changed to: \(newValue)")

                    let (weights, sprints, conditioning) = phaseManager.getDayData(viewModel: viewModel)
                    weightExercises = weights
                    accelerationExercises = sprints
                    conditioningExercises = conditioning

//                    dayExerciseList = phaseManager.getDayData(viewModel: viewModel)
                }

                viewModel.maxDataChanged = false
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
    ModelContextPreview(container: container) { modelContext in

        NavigationStack {
            let phaseManager = PhaseManager(modelContext: modelContext)

            CurrentDayWorkoutView()
                //        .modelContainer(for: Item.self, inMemory: true)
                .modelContainer(for: MaxIntensityRecord.self)
                .environmentObject(NavigationManager())
                .environmentObject(phaseManager)
        }
    }
    .modelContainer(container)
}
