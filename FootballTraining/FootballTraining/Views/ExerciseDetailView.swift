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
    
//    @State var selectedExercise: DayExercise
    @State var gotoToMaxHistory = false
    @State var gotoToExercise = false
//    @State var selectedExerciseIndex: Int
    
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
    
//            Spacer()
//                .frame(maxWidth: .infinity)
//                .background(Color(UIColor(red: 235 / 255, green: 235 / 255, blue: 235 / 255, alpha: 1.0)))
            
            Spacer().frame(height: 10)
            
            Button(action: {
//                gotoToExercise = true
                navigationManager.path.append(Route2.currentSet)

            }) {
                Text("Start Exercise")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(Color(hex: "7FBF30"))
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            .disabled(viewModel.selectedExerciseIndex != viewModel.lastCompletedItem)
            .opacity(viewModel.selectedExerciseIndex != viewModel.lastCompletedItem ? 0.75 : 1.0)
//            .padding([.leading, .trailing], 16)
            
            Spacer().frame(height: 10)
            
            Button(action: {
//                gotoToMaxHistory = true
                navigationManager.path.append(Route2.maxHistory)
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
//        .navigationDestination(isPresented: $gotoToMaxHistory) {
//            MaxHistoryView()
//        }
//        .navigationDestination(isPresented: $gotoToExercise) {
//            CurrentSetView()
//        }
        .onChange(of: viewModel.selectedExercise.max) { newMax in
            
            print("max changed to: \(newMax)")
//            weekChanged(to: newWeek)
        }
    }
}

#Preview {
    NavigationStack {
        ExerciseDetailView(
            //            selectedExercise: DayExercise(text: "0 x .68", type: "Basic", name: "Bench Press", sets: [], max: 1.0)
        )
        .environmentObject(NavigationManager())
    }
}
