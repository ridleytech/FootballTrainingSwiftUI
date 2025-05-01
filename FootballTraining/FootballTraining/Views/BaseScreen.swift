//
//  BaseScreen.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import SwiftUI

struct BaseScreen: View {
    @State var goToWorkout = false
    @Binding var currentPhase: String
    @Binding var currentDay: String
    @Binding var currentWeek: Int
    @Binding var lastCompletedItem: Int
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        VStack {
//            Spacer().frame(height: 30)
//            Text("Football Training")
//                .font(.system(size: 18, weight: .bold, design: .default))
//                .foregroundColor(AppConfig.greenColor)

            Spacer().frame(height: 20)

            HStack {
                VStack(alignment: .leading) {
                    Text("Phase: ")
                        .font(.system(size: 16, weight: .bold, design: .default))
                        + Text("\(currentPhase) Week \(currentWeek)")

                    Spacer().frame(height: 5)

                    Text("Day: ")
                        .font(.system(size: 16, weight: .bold, design: .default))
                        + Text(currentDay)

                    Spacer()
                }

                Spacer()
            }

            Button(action: {
                goToWorkout = true
//                        navigationManager.path.append(Route.dayWorkout)
            }) {
                Text("Train")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(Color(hex: "7FBF30"))
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
        }
//        .padding([.leading, .trailing], 16)
        .navigationDestination(isPresented: $goToWorkout) {
            DayWorkoutView(currentPhase: $currentPhase, currentDay: $currentDay, currentWeek: $currentWeek, lastCompletedItem: $lastCompletedItem)
        }
//        .navigationDestination(for: Route.self) { route in
//            switch route {
//            case .dayWorkout:
//                DayWorkoutView(currentPhase: .constant("Postseason"), currentDay: .constant("Monday"), currentWeek: .constant("1"))
//            default:
//                EmptyView()
//            }
//        }
        //        .background(Color.pink)
    }
}

#Preview {
    NavigationStack {
//        ContentView(currentPhase: .constant("Postseason"), currentDay: .constant("Monday"), currentWeek: .constant("1"))
//
        BaseScreen(
            currentPhase: .constant("Postseason"),
            currentDay: .constant("Monday"),
            currentWeek: .constant(1),
            lastCompletedItem: .constant(0))
            .environmentObject(NavigationManager())
    }
}
