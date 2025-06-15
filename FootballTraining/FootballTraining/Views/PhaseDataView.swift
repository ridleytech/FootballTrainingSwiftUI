//
//  PhaseDataView.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import SwiftUI

struct PhaseDataView: View {
    @State var goToWorkout = false
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var viewModel: PhaseViewModel

    var body: some View {
        VStack {
            Spacer().frame(height: 20)

            HStack {
                VStack(alignment: .leading) {
                    Text("Phase: ")
                        .font(.system(size: 16, weight: .bold, design: .default))
                        + Text("\(viewModel.currentPhase) Week \(viewModel.currentWeek)")

                    Spacer().frame(height: 5)

                    Text("Day: ")
                        .font(.system(size: 16, weight: .bold, design: .default))
                        + Text(viewModel.currentDay)

                    Spacer()
                }

                Spacer()
            }

            Button(action: {
                navigationManager.path.append(Route.dayWorkout)
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
    }
}

#Preview {
    NavigationStack {
        PhaseDataView(
            //            currentPhase: .constant("Postseason"),
//            currentDay: .constant("Monday"),
//            currentWeek: .constant(1),
        )
        .environmentObject(NavigationManager())
        .environmentObject(PhaseViewModel())
    }
}
