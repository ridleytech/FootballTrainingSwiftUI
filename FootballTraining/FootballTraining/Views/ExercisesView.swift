//
//  ExerciseView.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import SwiftUI

struct ExercisesView: View {
    @Binding var currentDay: String
    @Binding var lastCompletedItem: Int
    @State var gotoToExercise = false
    @State var selectedExercise: DayExercises?
    @EnvironmentObject var navigationManager: NavigationManager
    let exercises: [DayExercises]
    @State var exerciseIndex: Int = 0

    func completeWorkout() {
        print("completeWorkout")
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
                        exerciseIndex: $exerciseIndex
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
            ExerciseDetailView(selectedExercise: selectedExercise ?? DayExercises(text: "String", type: "String", name: "String", sets: [], max: 1.0), lastCompletedItem: $lastCompletedItem, selectedExerciseIndex: exerciseIndex)
        }
        .onAppear {
            print("ExerciseView lastCompletedItem: \(lastCompletedItem)")
        }
        .ignoresSafeArea(.container, edges: .bottom)
//        .navigationDestination(for: Route.self) { route in
//            switch route {
//            case .exerciseDetail:
//                ExerciseDetailView(exerciseName: $exerciseName, selectedExercise: selectedExercise ?? (text: "String", type: "String", name: "String", sets: [], max: 1.0))
//            default:
//                EmptyView()
//            }
//        }
    }
}

#Preview {
    NavigationStack {
        ExercisesView(currentDay: .constant("Monday"),
                      lastCompletedItem: .constant(0),
                      exercises: [
                          DayExercises(text: ".68 x 8",
                                       type: "Basic",
                                       name: "Bench Press", sets: [], max: 1.0),
                          DayExercises(text: ".68 x 8",
                                       type: "Basic",
                                       name: "Bench Press", sets: [], max: 1.0),
                          DayExercises(text: ".68 x 8",
                                       type: "Basic",
                                       name: "Bench Press", sets: [], max: 1.0),
                          DayExercises(text: ".68 x 8",
                                       type: "Basic",
                                       name: "Bench Press", sets: [], max: 1.0),
                          DayExercises(text: ".68 x 8",
                                       type: "Basic",
                                       name: "Bench Press", sets: [], max: 1.0),
                          DayExercises(text: ".68 x 8",
                                       type: "Basic",
                                       name: "Bench Press", sets: [], max: 1.0),
                          DayExercises(text: ".68 x 8",
                                       type: "Basic",
                                       name: "Bench Press", sets: [], max: 1.0),
                      ])
                      .environmentObject(NavigationManager())
    }
}
