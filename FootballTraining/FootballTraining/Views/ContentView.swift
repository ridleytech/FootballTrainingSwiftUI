//
//  ContentView.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import SwiftData
import SwiftUI

class PhaseViewModel: ObservableObject {
    @Published var currentPhase: String = "Postseason"
    @Published var currentWeek: Int = 1
    @Published var currentDay: String = "Monday"
    @Published var selectedExercise: DayExercise?
    @Published var lastCompletedItem: Int = 0
    @State var phases = ["Postseason", "Winter", "Spring", "Summer", "Preseason", "In-Season"]
    @Published var weeks = [1, 2, 3, 4, 5, 6, 7]
    @Published var days = ["Monday", "Tuesday", "Thursday", "Friday"]
    @Published var pickingPhase = false
}

struct ContentView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var phaseManager: PhaseManager

    @StateObject var viewModel = PhaseViewModel()

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
                            viewModel.pickingPhase.toggle()

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

                if viewModel.pickingPhase {
                    PhasePickerView(
                        //                        selectedPhase: $viewModel.currentPhase,
//                        selectedWeek: $viewModel.currentWeek,
//                        selectedDay: $viewModel.currentDay,
//                        lastCompletedItem: $viewModel.lastCompletedItem,
//                        phases: $viewModel.phases,
//                        days: $viewModel.days, weeks: $viewModel.weeks
                    )
                    // .background(Color.red)

                    Spacer()
                } else {
                    PhaseDataView(
                        currentPhase: $viewModel.currentPhase,
                        currentDay: $viewModel.currentDay,
                        currentWeek: $viewModel.currentWeek,
                        lastCompletedItem: $viewModel.lastCompletedItem
                    )
                }
            }
            .padding([.leading, .trailing], 16)
            .environmentObject(viewModel)
        }
        .onAppear {
            print("ContentView loaded saved phase: \(phaseManager.phaseRecord?.phaseName)")

            // Set the initial phase data on the screen

            if let phaseRecord = phaseManager.phaseRecord {
                viewModel.currentPhase = phaseRecord.phaseName
                viewModel.currentWeek = phaseRecord.phaseWeek
                viewModel.currentDay = phaseRecord.phaseDay
                viewModel.lastCompletedItem = phaseRecord.lastCompletedItem
                viewModel.weeks = Array(1 ..< phaseRecord.phaseWeekTotal)
            } else {
//                selectedPhase = "Postseason"
//                selectedWeek = 1
//                selectedDay = "Monday"
            }
        }
        .onChange(of: viewModel.pickingPhase) { _ in
//            print("pickingPhase to: \(newValue)")
        }
        .onChange(of: phaseManager.phaseRecord) { record in
            print("ContentView phaseInfo changed to: \(record)")
        }
        .tint(AppConfig.greenColor)
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
