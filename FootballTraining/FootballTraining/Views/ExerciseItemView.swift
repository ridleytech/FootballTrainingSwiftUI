//
//  ExerciseItemView.swift
//  FootballTraining
//
//  Created by Randall Ridley on 5/2/25.
//

import SwiftUI

struct ExerciseItemView: View {
    var exercise: DayExercises
    var index: Int
    @Binding var lastCompletedItem: Int
    @Binding var selectedExercise: DayExercises?
    @Binding var gotoToExercise: Bool
    @Binding var exerciseIndex: Int

    var body: some View {
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
            //                        if lastCompletedItem == index {
            selectedExercise = exercise
            gotoToExercise = true
            exerciseIndex = index
            //                        }
        }
        .listRowBackground(lastCompletedItem != index ? Color.white.opacity(0.5) : Color.white)
        .padding(16)
        .listRowInsets(EdgeInsets())
    }
}

#Preview {
    ExerciseItemView(
        exercise: DayExercises(text: ".68 x 8", type: "Basic", name: "Bench Press", sets: [], max: 1.0),
        index: 0,
        lastCompletedItem: .constant(0),
        selectedExercise: .constant(nil),
        gotoToExercise: .constant(false),
        exerciseIndex: .constant(0)
    )
}
