//
//  ExerciseView.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import SwiftUI

struct ExercisesListView: View {
    @Binding var currentDay: String
    @Binding var lastCompletedItem: Int
    @State var gotoToExercise = false
    @State var selectedExercise: DayExercise?
    @EnvironmentObject var navigationManager: NavigationManager
    let exercises: [DayExercise]
    @Binding var maxDataChanged: Bool
    @State var exerciseIndex: Int = 0
    @State var tappedExercise = false
    @State var tappedItemIndex: Int = 0

    func completeWorkout() {
        print("completeWorkout")
        navigationManager.path.removeLast(1)
    }

    func updateLastCompletedItem() {
        print("Complete Set tappedItemIndex: \(tappedItemIndex)")

//                lastCompletedItem = tappedItemIndex
        lastCompletedItem += 1

        print("Complete Set lastCompletedItem: \(lastCompletedItem)")
    }

    var body: some View {
        VStack {
            ZStack {
                Spacer()

                Text("\(currentDay)")
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
                            //                        .frame(maxWidth: .infinity)
                            .frame(width: 25, height: 25)
                            .background(Color(hex: "7FBF30"))
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                    Spacer().frame(width: 16)
                }
            }

            ZStack(alignment: .bottom) {
                List(Array(exercises.enumerated()), id: \.element.id) { index, exercise in
                    ExerciseItemView(
                        exercise: exercise,
                        index: index,
                        lastCompletedItem: $lastCompletedItem,
                        selectedExercise: $selectedExercise,
                        gotoToExercise: $gotoToExercise,
                        exerciseIndex: $exerciseIndex,
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
        .navigationDestination(isPresented: $gotoToExercise) {
            ExerciseDetailView(selectedExercise: selectedExercise ?? DayExercise(text: "String", type: "String", name: "String", sets: [], max: 1.0), lastCompletedItem: $lastCompletedItem, selectedExerciseIndex: exerciseIndex, maxDataChanged: $maxDataChanged)
        }
        .onAppear {
//            print("ExerciseView lastCompletedItem: \(lastCompletedItem)")
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .alert(selectedExercise?.name ?? "", isPresented: $tappedExercise) {
            Button("View Details") {
                print("View Details")

                gotoToExercise = true
            }
            Button("Complete Set") {
                updateLastCompletedItem()
            }
            Button("Cancel", role: .cancel) {}
        }
        .onChange(of: tappedItemIndex) { newValue in
            print("tappedItemIndex changed to: \(newValue)")
        }
        .onChange(of: lastCompletedItem) { newValue in
            print("Exercises view lastCompletedItem changed to: \(newValue)")
        }
        .onChange(of: gotoToExercise) { newValue in
            print("gotoToExercise changed to: \(newValue)")

            if gotoToExercise {
                print("gotoToExercise is true")

//                navigationManager.path.append(Route.exerciseDetail)
            }
        }
//        .navigationDestination(for: Route.self) { route in
//            switch route {
//            case .exerciseDetail:
//                ExerciseDetailView(selectedExercise: selectedExercise ?? DayExercise(text: "String", type: "String", name: "String", sets: [], max: 1.0), lastCompletedItem: $lastCompletedItem, selectedExerciseIndex: exerciseIndex, maxDataChanged: $maxDataChanged)
//            default:
//                EmptyView()
//            }
//        }
        .onAppear {
//            gotoToExercise = false
        }
    }
}

#Preview {
    NavigationStack {
        ExercisesListView(currentDay: .constant("Monday"),
                          lastCompletedItem: .constant(0),
                          exercises: [
                              DayExercise(text: ".68 x 8",
                                           type: "Basic",
                                           name: "Bench Press", sets: [], max: 1.0),
                              DayExercise(text: ".68 x 8",
                                           type: "Basic",
                                           name: "Military Press", sets: [], max: 1.0),
                              DayExercise(text: ".68 x 8",
                                           type: "Basic",
                                           name: "Bench Press", sets: [], max: 1.0),
                              DayExercise(text: ".68 x 8",
                                           type: "Basic",
                                           name: "Bench Press", sets: [], max: 1.0),
                              DayExercise(text: ".68 x 8",
                                           type: "Basic",
                                           name: "Bench Press", sets: [], max: 1.0),
                              DayExercise(text: ".68 x 8",
                                           type: "Basic",
                                           name: "Bench Press", sets: [], max: 1.0),
                              DayExercise(text: ".68 x 8",
                                           type: "Basic",
                                           name: "Bench Press", sets: [], max: 1.0),
                          ], maxDataChanged: .constant(false))
            .environmentObject(NavigationManager())
    }
}
