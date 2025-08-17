//
//  ExerciseDetail.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import SwiftUI

struct ExerciseDetailView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var viewModel: PhaseViewModel
    
    @State var gotoToMaxHistory = false
    @State var gotoToExercise = false
    
    var body: some View {
        VStack {
            Text(viewModel.selectedExercise.name)
                .font(.system(size: 18, weight: .bold, design: .default))
                .foregroundColor(AppConfig.greenColor)
            Spacer().frame(height: 10)

            VStack {
                Spacer()
                Image("AppIconSplash")
                    .resizable()
                    .frame(width: 300, height: 300)
                   
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(AppConfig.greenColor)
            .opacity(0)
            
            Spacer().frame(height: 10)
            
            Button(action: {
                navigationManager.path.append(Route.currentSet)

            }) {
                Text("Start Exercise")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(Color(hex: "7FBF30"))
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
//            .disabled(viewModel.selectedExerciseIndex != viewModel.lastCompletedItem)
//            .opacity(viewModel.selectedExerciseIndex != viewModel.lastCompletedItem ? 0.75 : 1.0)
            
            Spacer().frame(height: 10)
            
            Button(action: {
                navigationManager.path.append(Route.maxHistory)
            }) {
                Text("Max History")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(Color(hex: "7FBF30"))
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
        }
        .padding([.leading, .trailing], 16)
        .onChange(of: viewModel.selectedExercise.max) { newMax in
            print("max changed to: \(newMax)")
        }
    }
}

#Preview {
    NavigationStack {
        ExerciseDetailView(
            //            selectedExercise: DayExercise(text: "0 x .68", type: "Basic", name: "Bench Press", sets: [], max: 1.0)
        )
        .environmentObject(NavigationManager())
        .environmentObject(PhaseViewModel())
    }
}
