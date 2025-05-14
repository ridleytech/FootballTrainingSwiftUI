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

    @State private var dayExerciseList: [DayExercise] = []
    @State private var selectedItems: Set<String> = []

    let phaseOptions = ["Postseason", "Winter", "Spring", "Summer", "Preseason", "In-Season"]

    var body: some View {
        if dayExerciseList.isEmpty {
            ProgressView("Loading...")
                .onAppear {
                    dayExerciseList = phaseManager.getDayData(viewModel: viewModel)
                }

        } else {
            ExercisesListView(
                dayExerciseList: dayExerciseList
            )
            .onChange(of: viewModel.lastCompletedItem) { newValue in
                print("CurrentDayWorkoutView lastCompletedItem changed to: \(newValue)")

                ModelUtils.savePhase(phaseOptions: phaseOptions, dayExerciseCount: dayExerciseList.count, lastCompletedItem: &viewModel.lastCompletedItem, currentPhase: &viewModel.currentPhase, currentDay: &viewModel.currentDay, currentWeek: &viewModel.currentWeek, phaseManager: phaseManager, modelContext: modelContext)

                if viewModel.lastCompletedItem == 0 {
                    dayExerciseList = phaseManager.getDayData(viewModel: viewModel)
                }
            }
            .onChange(of: viewModel.maxDataChanged) { newValue in

                if viewModel.maxDataChanged {
                    print("maxDataChanged changed to: \(newValue)")
                    dayExerciseList = phaseManager.getDayData(viewModel: viewModel)
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
        let phaseManager = PhaseManager(modelContext: modelContext)

        return NavigationStack {
            CurrentDayWorkoutView(
                //                currentPhase: .constant("Preseason"), currentDay: .constant("Monday"), currentWeek: .constant(1), lastCompletedItem: .constant(0)
            )
            //        .modelContainer(for: Item.self, inMemory: true)
            .modelContainer(for: MaxIntensityRecord.self)
            .environmentObject(NavigationManager())
            .environmentObject(phaseManager)
        }
    }
    .modelContainer(container)
}
