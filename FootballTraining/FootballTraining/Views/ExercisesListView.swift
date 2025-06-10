//
//  ExerciseView.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import SwiftUI

struct ExercisesListView: View {
    @EnvironmentObject var viewModel: PhaseViewModel
    @EnvironmentObject var navigationManager: NavigationManager

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

        viewModel.lastCompletedItem = weightExercises.count + accelerationExercises.count + conditioningExercises.count
    }

    func updateLastCompletedItem() {
        print("Complete Set tappedItemIndex: \(tappedItemIndex)")

//        viewModel.lastCompletedItem += 1
        //
        //            print("Complete Set lastCompletedItem: \(viewModel.lastCompletedItem)")

        if viewModel.selectedSectionIndex == 0 {
            viewModel.completedDayAccelerationExercises.append(accelerationExercises[tappedItemIndex].name)

            print("ELV viewModel.completedDayAccelerationExercises: \(viewModel.completedDayAccelerationExercises)")
        }
        else if viewModel.selectedSectionIndex == 1 {
            viewModel.completedDayConditioningExercises.append(conditioningExercises[tappedItemIndex].name)

            print("ELV viewModel.completedDayConditioningExercises: \(viewModel.completedDayConditioningExercises)")
        }
        else if viewModel.selectedSectionIndex == 2 {
            viewModel.completedDayExercises.append(weightExercises[tappedItemIndex].name)

            print("ELV viewModel.completedDayExercises: \(viewModel.completedDayExercises)")
        }
    }

    var body: some View {
        VStack {
            ZStack {
                Spacer()

                Text("\(viewModel.currentDay)")
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
        .onAppear {
//            if let exercise = conditioningExercises.first {
//                print("conditioningExercises: \(exercise.description)")
//            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .alert(viewModel.selectedExercise.name ?? "", isPresented: $tappedExercise) {
            Button("View Details") {
                navigationManager.path.append(Route2.exerciseDetail)
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
        .onChange(of: viewModel.lastCompletedItem) { newValue in
            print("Exercises view lastCompletedItem changed to: \(newValue)")
        }
        .onChange(of: gotoToExercise) { _ in
//            print("gotoToExercise changed to: \(newValue)")

            if gotoToExercise {
                print("gotoToExercise is true")

                navigationManager.path.append(Route2.exerciseDetail)
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
