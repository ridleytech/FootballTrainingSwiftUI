//
//  ExerciseView.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import SwiftUI

struct ExercisesView: View {
    @Binding var currentDay: String
    let exercises: [(text: String, type: String, name: String, sets: [SetElement], max: Double)]
    @Binding var completedExercises: [(text: String, type: String, name: String, sets: [SetElement], max: Double)]
    @Binding var lastCompletedItem: Int
    @State var gotoToExercise = false
    @State var exerciseName = ""
    @State var selectedExercise: (text: String, type: String, name: String, sets: [SetElement], max: Double)?
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        VStack {
            Text("\(currentDay)")
                .font(.system(size: 18, weight: .bold, design: .default))
                .foregroundColor(AppConfig.greenColor)

//            List(exercises, id: \.text) { exercise in
            List(Array(exercises.enumerated()), id: \.element.text) { index, exercise in

                HStack {
                    VStack {
                        HStack {
                            Utils.iconForExerciseType2(exercise.type)
                                //                            .font(.system(size: 16, weight: .medium, design: .default))
                                .frame(width: 25, height: 25)
                                .background(exercise.type == "Basic" ? Color.blue : Color.red)
                                .foregroundColor(Color.white)
                                .cornerRadius(5)
                                .padding(.trailing, 2)

                            Text(exercise.name)
                                .font(.system(size: 16, weight: .medium, design: .default))
                            Spacer()
                        }

                        HStack {
                            Text(exercise.text)
                                .padding(.leading, 8)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
//                        .background(Color.white)
                        .padding(.vertical, 8)
                    }

                    if index < lastCompletedItem && index > -1 {
                        Image("ava-logo-bg").resizable().frame(width: 25, height: 25).scaledToFit()
                    }
                }
//                .disabled(lastCompletedItem != index)
                .onTapGesture {
                    if lastCompletedItem == index {
                        exerciseName = exercise.name
                        selectedExercise = exercise
                        gotoToExercise = true
                    }

//                    navigationManager.path.append(Route.exerciseDetail)
                }
                .listRowBackground(lastCompletedItem != index ? Color(UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)) : Color.white)
            }

            // .navigationTitle("\(currentDay) Lifts")
        }
        .navigationDestination(isPresented: $gotoToExercise) {
            ExerciseDetailView(exerciseName: $exerciseName, selectedExercise: selectedExercise ?? (text: "String", type: "String", name: "String", sets: [], max: 1.0), lastCompletedItem: $lastCompletedItem)
        }
        .onAppear {
            print("ExerciseView lastCompletedItem: \(lastCompletedItem)")
        }
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
                      exercises: [(text: ".68 x 8",
                                   type: "Basic",
                                   name: "Bench Press", sets: [], max: 1.0)], completedExercises: .constant([]), lastCompletedItem: .constant(0))
            .environmentObject(NavigationManager())
    }
}
