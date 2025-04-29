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
                            iconForExerciseType2(exercise.type)
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
                            //                    iconForExerciseType(exercise.type)
                            //                        .resizable()
                            //                        .frame(width: 24, height: 24)
                            //                        .scaledToFill()
                            Text(exercise.text)
                                .padding(.leading, 8)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .padding(.vertical, 8)
                    }
                    
                    if index < lastCompletedItem && index > -1 {
                        Image("ava-logo-bg").resizable().frame(width: 25, height: 25).scaledToFit()
                    }
                }
                .onTapGesture {
                    exerciseName = exercise.name
                    selectedExercise = exercise
                    gotoToExercise = true
//                    navigationManager.path.append(Route.exerciseDetail)
                }
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
    
    func iconForExerciseType(_ type: String) -> Image {
        switch type {
        case "Basic":
            return Image(systemName: "dumbbell.fill")
            
        case "Conditioning":
            return Image(systemName: "figure.run")
        default:
            return Image(systemName: "questionmark.circle.fill")
        }
    }
    
    func iconForExerciseType2(_ type: String) -> Text {
        switch type {
        case "Basic":
            return Text("B")
        case "Conditioning":
            return Text("C")
        case "Supporting":
            return Text("S")
        default:
            return Text("A")
        }
    }
}

#Preview {
    NavigationStack {
        ExercisesView(currentDay: .constant("Monday"),
                      exercises: [(text: ".68 x 8",
                                   type: "Basic",
                                   name: "Bench Press", sets: [], max: 1.0)], completedExercises: .constant([]), lastCompletedItem: .constant(-1))
            .environmentObject(NavigationManager())
    }
}
