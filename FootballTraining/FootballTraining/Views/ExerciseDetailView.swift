//
//  ExerciseDetail.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import SwiftUI

struct ExerciseDetailView: View {
    @State var selectedExercise: DayExercises
    @Binding var lastCompletedItem: Int
    @State var gotoToMaxHistory = false
    @State var gotoToExercise = false
    @State var selectedExerciseIndex: Int
    @Binding var maxDataChanged: Bool
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        VStack {
            Text(selectedExercise.name)
                .font(.system(size: 18, weight: .bold, design: .default))
                .foregroundColor(AppConfig.greenColor)
            Spacer().frame(height: 10)

            VStack {
                Spacer()
                Image("AppIconSplash")
                    .resizable()
                    .frame(width: 300, height: 300)
//                    .scaledToFill()
//                    .frame(maxWidth: .infinity)
                //                .frame(height: 600)
                   
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(AppConfig.greenColor)
    
//            Spacer()
//                .frame(maxWidth: .infinity)
//                .background(Color(UIColor(red: 235 / 255, green: 235 / 255, blue: 235 / 255, alpha: 1.0)))
            
            Spacer().frame(height: 10)
            
//            Button("Max History"){
//
//                gotoToMaxHistory = true
//            }
//            .font(.system(size: 16, weight: .bold, design: .default))
//            .frame(maxWidth: .infinity)
//            .frame(height: 45)
//            .background(Color(hex: "7FBF30"))
//            .foregroundColor(Color.white)
//            .padding([.leading, .trailing] ,16)
//
//            Spacer()
            
            Button(action: {
                gotoToExercise = true
            }) {
                Text("Start Exercise")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(Color(hex: "7FBF30"))
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            .disabled(selectedExerciseIndex != lastCompletedItem)
            .opacity(selectedExerciseIndex != lastCompletedItem ? 0.75 : 1.0)
//            .padding([.leading, .trailing], 16)
            
            Spacer().frame(height: 10)
            
            Button(action: {
                gotoToMaxHistory = true
//                navigationManager.path.append(Route.currentSet)
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
        .navigationDestination(for: Route.self) { route in
            switch route {
            case .currentSet:
                CurrentSetView(dayExercises: selectedExercise, lastCompletedItem: $lastCompletedItem)
            default:
                EmptyView()
            }
        }
        
        .navigationDestination(isPresented: $gotoToMaxHistory) {
            MaxHistoryView(selectedExercise: $selectedExercise, maxDataChanged: $maxDataChanged)
        }
        .navigationDestination(isPresented: $gotoToExercise) {
            CurrentSetView(dayExercises: selectedExercise, lastCompletedItem: $lastCompletedItem)
        }
        .onChange(of: selectedExercise.max) { newMax in
            
            print("max changed to: \(newMax)")
//            weekChanged(to: newWeek)
        }
        
//        SaveMax(exerciseName: $exerciseName)
    }
}

#Preview {
    NavigationStack {
        ExerciseDetailView(selectedExercise: DayExercises(text: "0 x .68", type: "Basic", name: "Bench Press", sets: [], max: 1.0),
                           lastCompletedItem: .constant(0), selectedExerciseIndex: 1, maxDataChanged: .constant(false))
            .environmentObject(NavigationManager())
    }
}
