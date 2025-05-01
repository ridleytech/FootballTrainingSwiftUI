//
//  ExerciseView.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import SwiftUI

struct ExercisesView: View {
    @Binding var currentDay: String
    let exercises: [DayExercises]
    @Binding var lastCompletedItem: Int
    @State var gotoToExercise = false
    @State var selectedExercise: DayExercises?
    @EnvironmentObject var navigationManager: NavigationManager

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
                }
            }

            ZStack(alignment: .bottom) {
                List(Array(exercises.enumerated()), id: \.element.id) { index, exercise in
                    HStack {
                        VStack {
                            HStack {
                                Utils.iconForExerciseType2(exercise.type)
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
                            .padding(.vertical, 8)
                        }

                        if index < lastCompletedItem && index > -1 {
                            Image("AppIconSplash")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .scaledToFit()
                        }
                    }
                    .onTapGesture {
                        if lastCompletedItem == index {
                            selectedExercise = exercise
                            gotoToExercise = true
                        }
                    }
                    .listRowBackground(lastCompletedItem != index ? Color.white.opacity(0.5) : Color.white)
                    .padding(16)
                    .listRowInsets(EdgeInsets())
                }
//                .listStyle(.plain)

                // 👇 Bottom shadow overlay
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.05), Color.clear]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 20)
                .allowsHitTesting(false)
            }

            Spacer().frame(height: 10)

//            Button(action: {
//                completeWorkout()
//
//            }) {
//                Text("Complete Workout")
//                    .font(.system(size: 16, weight: .bold, design: .default))
//                    .frame(maxWidth: .infinity)
//                    .frame(height: 45)
//                    .background(Color(hex: "7FBF30"))
//                    .foregroundColor(.white)
//                    .cornerRadius(5)
//            }

            // .navigationTitle("\(currentDay) Lifts")
        }
        .padding([.leading, .trailing], 16)
        .navigationDestination(isPresented: $gotoToExercise) {
            ExerciseDetailView(selectedExercise: selectedExercise ?? DayExercises(text: "String", type: "String", name: "String", sets: [], max: 1.0), lastCompletedItem: $lastCompletedItem)
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
                      exercises: [DayExercises(text: ".68 x 8",
                                               type: "Basic",
                                               name: "Bench Press", sets: [], max: 1.0), DayExercises(text: ".68 x 8",
                                                                                                      type: "Basic",
                                                                                                      name: "Bench Press", sets: [], max: 1.0), DayExercises(text: ".68 x 8",
                                                                                                                                                             type: "Basic",
                                                                                                                                                             name: "Bench Press", sets: [], max: 1.0), DayExercises(text: ".68 x 8",
                                                                                                                                                                                                                    type: "Basic",
                                                                                                                                                                                                                    name: "Bench Press", sets: [], max: 1.0), DayExercises(text: ".68 x 8",
                                                                                                                                                                                                                                                                           type: "Basic",
                                                                                                                                                                                                                                                                           name: "Bench Press", sets: [], max: 1.0), DayExercises(text: ".68 x 8",
                                                                                                                                                                                                                                                                                                                                  type: "Basic",
                                                                                                                                                                                                                                                                                                                                  name: "Bench Press", sets: [], max: 1.0), DayExercises(text: ".68 x 8",
                                                                                                                                                                                                                                                                                                                                                                                         type: "Basic",
                                                                                                                                                                                                                                                                                                                                                                                         name: "Bench Press", sets: [], max: 1.0)], lastCompletedItem: .constant(0))
            .environmentObject(NavigationManager())
    }
}
