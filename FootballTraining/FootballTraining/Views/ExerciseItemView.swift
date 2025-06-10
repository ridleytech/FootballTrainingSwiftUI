//
//  ExerciseItemView.swift
//  FootballTraining
//
//  Created by Randall Ridley on 5/2/25.
//

import SwiftData
import SwiftUI

struct ExerciseItemView: View {
    let exerciseListItem: DayExercise
    let exerciseListItemIndex: Int
    @Binding var gotoToExercise: Bool
    @Binding var tappedExercise: Bool
    @Binding var tappedItemIndex: Int
    @Binding var section: Int
    let showExerciseType = false
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var viewModel: PhaseViewModel

    var body: some View {
        HStack {
            Utils.iconForExerciseType2(exerciseListItem.type)
                .frame(width: 50, height: 50)
                .background(exerciseListItem.type == "Basic" ? Color.blue : exerciseListItem.type == "Sprint" ? Color.red : exerciseListItem.type == "Plyometric" ? Color.yellow : Color.red)
                .foregroundColor(Color.white)
                .cornerRadius(5)
                .padding(.trailing, 5)
                .onTapGesture {
                    print("exercise type tapped: \(exerciseListItemIndex)")
                    viewModel.selectedExercise = exerciseListItem
                    tappedItemIndex = exerciseListItemIndex
                    viewModel.selectedSectionIndex = section
                    tappedExercise = true
                }

            VStack {
                HStack {
                    Text(exerciseListItem.name)
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .foregroundColor(AppConfig.grayColor)
//                        .font(.caption2)

                    Spacer()
                }
//                .background(Color.yellow)

                HStack {
                    Text(exerciseListItem.text)
                        .foregroundColor(AppConfig.grayColor)

//                        .padding(.leading, 8)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
//                .background(Color.red)
            }
//            .background(Color.orange)

//            if exerciseListItemIndex < viewModel.lastCompletedItem && exerciseListItemIndex > -1 {
//                Image("AppIconSplash")
//                    .resizable()
//                    .frame(width: 25, height: 25)
//                    .scaledToFit()
//            }

            if section == 0 && (viewModel.completedDayAccelerationExercises.index(of: exerciseListItem.id) != nil) {
                Image("AppIconSplash")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .scaledToFit()
            }
            else if section == 1 && viewModel.completedDayConditioningExercises.index(of: exerciseListItem.id) != nil {
                Image("AppIconSplash")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .scaledToFit()
            }
            else if viewModel.completedDayExercises.index(of: exerciseListItem.id) != nil {
                Image("AppIconSplash")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .scaledToFit()
            }
        }
        .onTapGesture {
            print("tapped")
            //                        if lastCompletedItem == index {
            viewModel.selectedExercise = exerciseListItem
            gotoToExercise = true
            viewModel.selectedExerciseIndex = exerciseListItemIndex
            //                        }
        }
        .listRowBackground(viewModel.lastCompletedItem != exerciseListItemIndex ? Color.white.opacity(0.5) : Color.white)
        .padding(16)
        .listRowInsets(EdgeInsets())
    }
}

#Preview {
    ExerciseItemView(
        exerciseListItem: DayExercise(
            text: "3 sets x 10",
            type: "Basic",
            name: "Mock",
            sets: [],
            max: 1.0
        ),
        exerciseListItemIndex: 0,
        gotoToExercise: .constant(false),
        tappedExercise: .constant(false),
        tappedItemIndex: .constant(0),
        section: .constant(0)
    )
    .environmentObject(NavigationManager())
    .environmentObject(PhaseViewModel())
}
