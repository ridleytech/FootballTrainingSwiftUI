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

    @State var gotoToExercise = false
    @State var selectedExercise: DayExercise?

    let dayExerciseList: [DayExercise]
    @State var exerciseIndex: Int = 0
    @State var tappedExercise = false
    @State var tappedItemIndex: Int = 0

    func completeWorkout() {
        print("completeWorkout")
//        navigationManager.path.removeLast(1)

        viewModel.lastCompletedItem = dayExerciseList.count
    }

    func updateLastCompletedItem() {
        print("Complete Set tappedItemIndex: \(tappedItemIndex)")

        viewModel.lastCompletedItem += 1

        print("Complete Set lastCompletedItem: \(viewModel.lastCompletedItem)")

//        ModelUtils.savePhase(phaseOptions: phaseOptions, dayExerciseCount: dayExerciseList.count, lastCompletedItem: &viewModel.lastCompletedItem, currentPhase: &viewModel.currentPhase, currentDay: &viewModel.currentDay, currentWeek: &viewModel.currentWeek, phaseManager: phaseManager, modelContext: modelContext)
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
                        Text("C")
                            .font(.system(size: 16, weight: .bold, design: .default))
                            // .frame(maxWidth: .infinity)
                            .frame(width: 25, height: 25)
                            .background(Color(hex: "7FBF30"))
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                    Spacer().frame(width: 16)
                }
            }

            ZStack(alignment: .bottom) {
                List(Array(dayExerciseList.enumerated()), id: \.element.id) { index, exercise in
                    ExerciseItemView(
                        exerciseListItem: exercise,
                        exerciseListItemIndex: index,
                        gotoToExercise: $gotoToExercise,
                        tappedExercise: $tappedExercise,
                        tappedItemIndex: $tappedItemIndex
                    )
                }
//                .listStyle(.plain)

                // 👇 Bottom shadow overlay
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.2), Color.clear]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 20)
                .allowsHitTesting(false)
            }

//            Spacer().frame(height: 10)

            // .navigationTitle("\(currentDay) Lifts")
        }
//        .padding([.leading, .trailing], 16)
//        .navigationDestination(isPresented: $gotoToExercise) {
//            ExerciseDetailView(
//                ////                selectedExercise: selectedExercise ?? DayExercise(text: "String", type: "String", name: "String", sets: [], max: 1.0),
        ////                selectedExerciseIndex: exerciseIndex
//            )
//        }
        .onAppear {
//            print("ExerciseView lastCompletedItem: \(lastCompletedItem)")
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .alert(viewModel.selectedExercise.name ?? "", isPresented: $tappedExercise) {
            Button("View Details") {
                print("View Details")

//                gotoToExercise = true
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
//        ExercisesListView(currentDay: .constant("Monday"),
//                          lastCompletedItem: .constant(0),
//                          exercises: [
//                              DayExercise(text: ".68 x 8",
//                                          type: "Basic",
//                                          name: "Bench Press", sets: [], max: 1.0),
//                              DayExercise(text: ".68 x 8",
//                                          type: "Basic",
//                                          name: "Military Press", sets: [], max: 1.0),
//                              DayExercise(text: ".68 x 8",
//                                          type: "Basic",
//                                          name: "Bench Press", sets: [], max: 1.0),
//                              DayExercise(text: ".68 x 8",
//                                          type: "Basic",
//                                          name: "Bench Press", sets: [], max: 1.0),
//                              DayExercise(text: ".68 x 8",
//                                          type: "Basic",
//                                          name: "Bench Press", sets: [], max: 1.0),
//                              DayExercise(text: ".68 x 8",
//                                          type: "Basic",
//                                          name: "Bench Press", sets: [], max: 1.0),
//                              DayExercise(text: ".68 x 8",
//                                          type: "Basic",
//                                          name: "Bench Press", sets: [], max: 1.0),
//                          ], maxDataChanged: .constant(false))
//            .environmentObject(NavigationManager())
    }
}
