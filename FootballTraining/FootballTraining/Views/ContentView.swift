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

    @StateObject var viewModel = PhaseViewModel()

    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack {
                Spacer()
                    .frame(height: 50)

                ZStack {
                    Spacer()

                    HStack {
                        Button(action: {
                            navigationManager.path.append(Route2.notification)

                        }) {
                            Image(systemName: "gearshape.fill")
                                .imageScale(.medium)
                                .padding(5)
                                .background(Color(hex: "7FBF30"))
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }

                        Spacer()
                    }

                    Text("Football Training")
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .foregroundColor(AppConfig.greenColor)

                    HStack {
                        Spacer()

                        Button(action: {
                            viewModel.pickingPhase.toggle()

                        }) {
                            Image(systemName: "moonphase.first.quarter")
                                .imageScale(.medium)
                                .padding(5)
                                .background(Color(hex: "7FBF30"))
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                    }
                }

                if viewModel.pickingPhase {
                    PhasePickerView()
                    // .background(Color.red)

                    Spacer()
                } else {
                    Spacer().frame(height: 20)
                    PhaseDataView()
                        .navigationDestination(for: Route2.self) { route in
                            switch route {
                            case .currentSet:
                                CurrentSetView()
                            case .dayWorkout:
                                CurrentDayWorkoutView()
                            case .exerciseDetail:
                                ExerciseDetailView()
                            case .maxHistory:
                                MaxHistoryView()
                            case .saveMax:
                                SaveMax()
                            case .notification:
                                NotificationSettings()
                            default:
                                EmptyView()
                            }
                        }
                }
            }
            .padding([.leading, .trailing], 16)
        }
        .onAppear {
            print("ContentView loaded saved phase: \(phaseManager.phaseRecord?.phaseName)")

            // Set the initial phase data on the screen

            if let phaseRecord = phaseManager.phaseRecord {
                viewModel.currentPhase = phaseRecord.phaseName
                viewModel.currentWeek = phaseRecord.phaseWeek
                viewModel.currentDay = phaseRecord.phaseDay
                viewModel.lastCompletedItem = phaseRecord.lastCompletedItem
                viewModel.weeks = Array(1 ..< phaseRecord.phaseWeekTotal + 1)
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
        .environmentObject(viewModel)

        // .background(Color.pink)
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
