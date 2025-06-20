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

    @State private var weightExercises: [DayExercise] = []
    @State private var accelerationExercises: [DayExercise] = []
    @State private var conditioningExercises: [ConditioningExercise] = []

    @State private var selectedItems: Set<String> = []
    @State var gotData: Bool = false

    func updatePhaseData(dayCompleted: Bool) {
        print("CDWV updatePhaseData")

        ModelUtils.updatePhase(
            dayExerciseCount: weightExercises.count + accelerationExercises.count + conditioningExercises.count,
            currentPhase: &viewModel.currentPhase,
            currentDay: &viewModel.currentDay,
            currentWeek: &viewModel.currentWeek,
            completedDayExercises: &viewModel.completedDayExercises,
            completedDayConditioningExercises: &viewModel.completedDayConditioningExercises,
            completedDayAccelerationExercises: &viewModel.completedDayAccelerationExercises, skippedExercises: &viewModel.skippedExercises,
            phaseManager: phaseManager,
            modelContext: modelContext,
            dayCompleted: dayCompleted
        )

        if dayCompleted == true {
            viewModel.dayCompleted = false
        }

        refreshDayData()
    }

    func refreshDayData() {
        let completedExerciseCount = viewModel.completedDayExercises.count + viewModel.completedDayConditioningExercises.count + viewModel.completedDayAccelerationExercises.count

        if completedExerciseCount == 0 {
            let (weights, sprints, conditioning) = phaseManager.getDayData(viewModel: viewModel)
            weightExercises = weights
            accelerationExercises = sprints
            conditioningExercises = conditioning

            //                    dayExerciseList = phaseManager.getDayData(viewModel: viewModel)
        }
    }

    var body: some View {
        if weightExercises.isEmpty && !gotData {
            ProgressView("Loading...")
                .onAppear {
                    let (weights, sprints, conditioning) = phaseManager.getDayData(viewModel: viewModel)

                    let updatedWeightExercises = weights.map { exercise -> DayExercise in
                        var modified = exercise
                        modified.trainingType = .weight
                        return modified
                    }

                    let updatedAccelExercises = sprints.map { exercise -> DayExercise in
                        var modified = exercise
                        modified.trainingType = .acceleration
                        return modified
                    }

                    let updatedConditioningExercises = conditioning.map { exercise -> DayExercise in
                        var modified = exercise
                        modified.trainingType = .conditioning
                        return modified
                    }

                    weightExercises = updatedWeightExercises
                    accelerationExercises = updatedAccelExercises
//                    conditioningExercises = updatedConditioningExercises

//                    print("cdwv weightExercises: \(weightExercises)")
//                    print("cdwv conditioningExercises: \(conditioningExercises)")

                    gotData = true
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

            ExercisesListView(weightExercises: weightExercises, accelerationExercises: accelerationExercises, conditioningExercises: convertedConditioning)
                .onChange(of: viewModel.dayCompleted) { newValue in
                    print("CDWV viewModel.dayCompleted changed to: \(newValue)")

                    updatePhaseData(dayCompleted: newValue)
                }
                .onChange(of: viewModel.completedDayExercises) { newValue in
                    print("CDWV viewModel.completedDayExercises changed to: \(newValue)")

                    updatePhaseData(dayCompleted: false)
                }
                .onChange(of: viewModel.completedDayAccelerationExercises) { newValue in
                    print("CDWV viewModel.completedDayAccelerationExercises changed to: \(newValue)")

                    updatePhaseData(dayCompleted: false)
                }
                .onChange(of: viewModel.completedDayConditioningExercises) { newValue in
                    print("CDWV viewModel.completedDayConditioningExercises changed to: \(newValue)")

                    updatePhaseData(dayCompleted: false)
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

struct CurrentDayWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        // 1. Create an in-memory SwiftData model container
        let schema = Schema([
            Item.self,
            MaxIntensityRecord.self,
            PhaseRecord.self,
            SkippedExercises.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])

        // 2. Create a mock navigation manager
        let navigationManager = NavigationManager()

        // 3. Use a context from the model container to create the PhaseManager
        return ModelContextPreview(container: container) { modelContext in
            let phaseManager = PhaseManager(modelContext: modelContext)

            return CurrentDayWorkoutView()
                .environmentObject(navigationManager)
                .environmentObject(phaseManager)
                .environmentObject(PhaseViewModel())
        }
        .modelContainer(container)
    }
}
