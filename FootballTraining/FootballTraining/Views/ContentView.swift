//
//  ContentView.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var phaseManager: PhaseManager

    @State var selectedPhase: String = "Postseason"
    @State var selectedWeek: Int = 1
    @State var selectedDay: String = "Monday"
    @State var lastCompletedItem: Int = 0
    @State private var phases = ["Postseason", "Winter", "Spring", "Summer", "Preseason", "In-Season"]
    @State private var weeks = [1, 2, 3, 4, 5, 6, 7]
    @State private var days = ["Monday", "Tuesday", "Thursday", "Friday"]
    @State private var pickingPhase = false

    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack {
                Spacer()
                    .frame(height: 50)

                ZStack {
                    Spacer()

                    Text("Football Training")
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .foregroundColor(AppConfig.greenColor)

                    HStack {
                        Spacer()
                        Button(action: {
                            pickingPhase.toggle()

                        }) {
                            Text("P")
                                .font(.system(size: 16, weight: .bold, design: .default))
                                .frame(width: 25, height: 25)
                                .background(Color(hex: "7FBF30"))
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                    }
                }

                if pickingPhase {
                    PhasePickerView(
                        selectedPhase: $selectedPhase,
                        selectedWeek: $selectedWeek,
                        selectedDay: $selectedDay,
                        lastCompletedItem: $lastCompletedItem,
                        phases: $phases,
                        days: $days, weeks: $weeks
                    )
                    // .background(Color.red)

                    Spacer()
                } else {
                    PhaseDataView(
                        currentPhase: $selectedPhase,
                        currentDay: $selectedDay,
                        currentWeek: $selectedWeek,
                        lastCompletedItem: $lastCompletedItem
                    )
                }
            }
            .padding([.leading, .trailing], 16)
        }
        .onChange(of: pickingPhase) { _ in
//            print("pickingPhase to: \(newValue)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // 1. Create an in-memory SwiftData model container
        let schema = Schema([
            Item.self,
            MaxIntensityRecord.self,
            PhaseRecord.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])

        // 2. Create a mock navigation manager
        let navigationManager = NavigationManager()

        // 3. Use a context from the model container to create the PhaseManager
        return ModelContextPreview(container: container) { modelContext in
            let phaseManager = PhaseManager(modelContext: modelContext)

            return ContentView()
                .environmentObject(navigationManager)
                .environmentObject(phaseManager)
        }
        .modelContainer(container)
    }
}
