//
//  ExerciseView.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import SwiftUI

struct ExercisesListView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var viewModel: PhaseViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var phaseManager: PhaseManager

    let weightExercises: [DayExercise]
    let accelerationExercises: [DayExercise]
    let conditioningExercises: [DayExercise]

    @State var gotoToExercise = false
    @State var selectedExercise: DayExercise?
    @State var exerciseIndex: Int = 0
    @State var tappedExercise = false
    @State var tappedItemIndex: Int = 0

    func completeWorkout() {
        print("completeWorkout")

        // handle updating skipped exercises

        if viewModel.viewingSkippedExercises == true {
            viewModel.skippedExercises.exercises = []
        }
        else {
            var skipped: [DayExercise] = []

            // 🏋️‍♂️ Weight Exercises
            let skippedWeights = weightExercises.filter { weightExercise in
                !viewModel.completedDayExercises.contains { completed in
                    completed.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                        == weightExercise.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                }
            }
            skipped.append(contentsOf: skippedWeights)

            // 🏃 Acceleration Exercises
            let skippedAcceleration = accelerationExercises.filter { accelExercise in
                !viewModel.completedDayAccelerationExercises.contains { completed in
                    completed.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                        == accelExercise.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                }
            }
            skipped.append(contentsOf: skippedAcceleration)

            // 🧘 Conditioning Exercises
            let skippedConditioning = conditioningExercises.filter { condExercise in
                !viewModel.completedDayConditioningExercises.contains { completed in
                    completed.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                        == condExercise.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                }
            }
            skipped.append(contentsOf: skippedConditioning)

            // 🧾 If any skipped exercises, record them
            if !skipped.isEmpty {
                let skippedRecord = SkippedExercises(exercises: skipped, date: Date(), day: viewModel.currentDay, week: viewModel.currentWeek)
                viewModel.skippedExercises = skippedRecord

                print("Skipped exercises: \(skipped.map { $0.name })")
            }

            // ✅ If all exercises completed
            viewModel.completedDayExercises = []
            viewModel.completedDayConditioningExercises = []
            viewModel.completedDayAccelerationExercises = []
            viewModel.dayCompleted = true
        }
    }

    func updateLastCompletedItem() {
        print("Complete Set tappedItemIndex: \(tappedItemIndex)")

        // handle updating skipped exercises

        if viewModel.viewingSkippedExercises == true {
            if viewModel.selectedSectionIndex == 0 {
                let findSkippedExercise = viewModel.skippedExercises.exercises.filter { exercise in
                    exercise.id
                        == accelerationExercises[tappedItemIndex].id
                }

                print("findSkippedExercise acc: \(findSkippedExercise)")
            }
            else if viewModel.selectedSectionIndex == 1 {
                let findSkippedExercise = viewModel.skippedExercises.exercises.filter { exercise in
                    exercise.id
                        == conditioningExercises[tappedItemIndex].id
                }

                print("findSkippedExercise con: \(findSkippedExercise)")
            }
            else if viewModel.selectedSectionIndex == 2 {
                print("weightExercises[tappedItemIndex].id: \(weightExercises[tappedItemIndex].id)")

                let mappedIds = viewModel.skippedExercises.exercises.map { $0.id }
//                print("mappedIds: \(mappedIds)")

                let mappedNames = viewModel.skippedExercises.exercises.map { $0.name }
//                print("mappedNames: \(mappedNames)")

                let findSkippedExercise = viewModel.skippedExercises.exercises.filter { exercise in
                    exercise.id
                        == weightExercises[tappedItemIndex].id
                }

                print("findSkippedExercise weight: \(findSkippedExercise)")
            }
        }
        else {
            if viewModel.selectedSectionIndex == 0 {
                viewModel.completedDayAccelerationExercises.append(accelerationExercises[tappedItemIndex])

                print("ELV viewModel.completedDayAccelerationExercises: \(viewModel.completedDayAccelerationExercises)")
            }
            else if viewModel.selectedSectionIndex == 1 {
                viewModel.completedDayConditioningExercises.append(conditioningExercises[tappedItemIndex])

                print("ELV viewModel.completedDayConditioningExercises: \(viewModel.completedDayConditioningExercises)")
            }
            else if viewModel.selectedSectionIndex == 2 {
                viewModel.completedDayExercises.append(weightExercises[tappedItemIndex])

                print("ELV viewModel.completedDayExercises: \(viewModel.completedDayExercises)")
            }
        }
    }

    var body: some View {
        VStack {
            ZStack {
                Spacer()

                Text(viewModel.viewingSkippedExercises == true ? "Skipped Exercises" : "\(viewModel.currentDay)")
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .foregroundColor(AppConfig.greenColor)

                Spacer()

                HStack {
                    Spacer()
                    Button(action: {
                        completeWorkout()

                    }) {
                        Image(systemName: "checkmark")
                            .imageScale(.medium)
                            .padding(5)
                            .background(Color(hex: "7FBF30"))
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                    Spacer().frame(width: 16)
                }
            }

            ZStack(alignment: .bottom) {
                List {
                    if !accelerationExercises.isEmpty {
                        Section(header: Text("Acceleration Training")) {
                            ForEach(Array(accelerationExercises.enumerated()), id: \.element.id) { index, exercise in

                                ExerciseItemView(
                                    exerciseListItem: exercise,
                                    exerciseListItemIndex: index,
                                    gotoToExercise: $gotoToExercise,
                                    tappedExercise: $tappedExercise,
                                    tappedItemIndex: $tappedItemIndex,
                                    section: .constant(0)
                                )
                            }
                        }
                    }

                    if !conditioningExercises.isEmpty {
                        Section(header: Text("Conditioning Training")) {
                            ForEach(Array(conditioningExercises.enumerated()), id: \.element.id) { index2, exercise in

                                ExerciseItemView(
                                    exerciseListItem: exercise,
                                    exerciseListItemIndex: index2,
                                    gotoToExercise: $gotoToExercise,
                                    tappedExercise: $tappedExercise,
                                    tappedItemIndex: $tappedItemIndex,
                                    section: .constant(1)
                                )
                            }
                        }
                    }

                    Section(header: Text("Weight Training")) {
                        ForEach(Array(weightExercises.enumerated()), id: \.element.id) { index3, exercise in

                            ExerciseItemView(
                                exerciseListItem: exercise,
                                exerciseListItemIndex: index3,
                                gotoToExercise: $gotoToExercise,
                                tappedExercise: $tappedExercise,
                                tappedItemIndex: $tappedItemIndex,
                                section: .constant(2)
                            )
                        }
                    }
                }
                // 👇 Bottom shadow overlay
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.2), Color.clear]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 20)
                .allowsHitTesting(false)
            }

            // .navigationTitle("\(currentDay) Lifts")
        }
        .onAppear {}
        .ignoresSafeArea(.container, edges: .bottom)
        .alert(viewModel.selectedExercise.name ?? "", isPresented: $tappedExercise) {
            Button("View Details") {
                navigationManager.path.append(Route.exerciseDetail)
            }
            Button("Complete Set") {
                updateLastCompletedItem()
            }
            Button("Cancel", role: .cancel) {}
        }
        .onChange(of: tappedItemIndex) { newValue in
            print("tappedItemIndex changed to: \(newValue)")
        }
        .onChange(of: viewModel.selectedSectionIndex) { newValue in
            print("viewModel.selectedSectionIndex changed to: \(newValue)")
        }
        .onChange(of: gotoToExercise) { _ in
//            print("gotoToExercise changed to: \(newValue)")

            if gotoToExercise {
                print("gotoToExercise is true")

                navigationManager.path.append(Route.exerciseDetail)
            }
        }
        .onAppear {
            gotoToExercise = false
        }
    }
}

#Preview {
    NavigationStack {
        ExercisesListView(
            weightExercises: [
                DayExercise(text: ".68 x 8",
                            type: "Basic",
                            name: "Bench Press", sets: [], max: 1.0),
                DayExercise(text: ".68 x 8",
                            type: "Basic",
                            name: "Military Press", sets: [], max: 1.0)
            ],
            accelerationExercises: [
                DayExercise(text: ".68 x 8",
                            type: "Sprint",
                            name: "Sled Push Sprints", sets: [], max: 1.0),
                DayExercise(text: ".68 x 8",
                            type: "Plyometric",
                            name: "Broad Jumps", sets: [], max: 1.0)
            ],
            conditioningExercises: [
                DayExercise(text: ".68 x 8",
                            type: "Sprint",
                            name: "Tempo runs", sets: [], max: 1.0)
            ]
        )
        .environmentObject(NavigationManager())
        .environmentObject(PhaseViewModel())
    }
}
