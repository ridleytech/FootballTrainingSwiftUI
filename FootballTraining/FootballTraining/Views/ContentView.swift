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
    @Environment(\.modelContext) private var modelContext

    @State private var kpis: [TrainingKPI] = []

    // FetchDescriptor to query TrainingKPI objects from SwiftData

    private func fetchKPIs() {
        // Define the FetchDescriptor for TrainingKPI
        let fetchDescriptor = FetchDescriptor<TrainingKPI>(
            sortBy: [SortDescriptor(\TrainingKPI.exerciseName)] // Corrected SortDescriptor usage
        )

        // Query the context with the FetchDescriptor
        do {
            kpis = try modelContext.fetch(fetchDescriptor)

            print("kpis: \(kpis.count)")

            if kpis.isEmpty {
                print("create kpis")
//
                Task {
                    preloadSampleKPIs(context: modelContext)
                }
            } else {
                let mm = MaxManager(modelContext: modelContext)

                if let weight = mm.weightRecord?.weight {
                    print("current weight: \(weight)")

                    let updatedKPIs = kpis.map { kpi in

                        let targetGoal = kpi.calculateTargetGoal(weight: weight)

                        if targetGoal != "N/A" {
                            kpi.targetGoal = kpi.calculateTargetGoal(weight: weight)
                        }
                    }

                    do { try modelContext.save(); print("kpis updated") } catch {}

//                    if let kpiTargetGoal = viewModel.selectedKPI.targetGoal {
//                        //                    print("range: \(kpiTargetGoal)")
//
                    ////                        targetGoal = kpiTargetGoal
//                    }
                }
            }
        } catch {
            print("Error fetching KPIs: \(error)")
        }
    }

    @MainActor
    func preloadSampleKPIs(context: ModelContext) {
        let todayDate = Date()

        let sampleKPIs: [TrainingKPI] = [
            TrainingKPI(exerciseName: "Squat", dateRecorded: todayDate, bodyWeightMultiplierMin: 1.5, bodyWeightMultiplierMax: 1.75, repsMin: 3, repsMax: 5, liftSpeedConcentricMin: 0.6, liftSpeedConcentricMax: 0.8, notes: "Heels elevated"),
            TrainingKPI(exerciseName: "Chin Up", dateRecorded: todayDate, repsMin: 10, repsMax: 12, notes: "Underhand grip"),
            TrainingKPI(exerciseName: "Trap Bar Deadlift", dateRecorded: todayDate, bodyWeightMultiplierMin: 2.0, bodyWeightMultiplierMax: 2.2, liftSpeedConcentricMin: 0.6, liftSpeedConcentricMax: 0.8),
            TrainingKPI(exerciseName: "Barbell RDL", dateRecorded: todayDate, bodyWeightMultiplierMin: 1.5, bodyWeightMultiplierMax: 1.75, repsMin: 3, repsMax: 5, liftSpeedConcentricMin: 0.6, liftSpeedConcentricMax: 0.8, notes: "Use straps)"),
            TrainingKPI(exerciseName: "Lateral Lunge", dateRecorded: todayDate, bodyWeightMultiplierMin: 0.4, bodyWeightMultiplierMax: 0.6, repsMin: 3, repsMax: 5),
            TrainingKPI(exerciseName: "Nordic Curl", dateRecorded: todayDate, liftSpeedEccentric: 3.0),
            TrainingKPI(exerciseName: "Calf Raise - Barbell on Chair", dateRecorded: todayDate, bodyWeightMultiplierMin: 1.5, bodyWeightMultiplierMax: 1.85, repsMin: 3, repsMax: 5),
            TrainingKPI(exerciseName: "Calf Raise - Single Leg", dateRecorded: todayDate, repsMin: 12, repsMax: 12),
            TrainingKPI(exerciseName: "Calf Raise - Machine", dateRecorded: todayDate, bodyWeightMultiplierMin: 2.0, bodyWeightMultiplierMax: 2.5, repsMin: 3, repsMax: 5),
            TrainingKPI(exerciseName: "Soleus Calf Raise - Smith Machine", dateRecorded: todayDate, bodyWeightMultiplierMin: 1.5, bodyWeightMultiplierMax: 2.0, repsMin: 3, repsMax: 5),
            TrainingKPI(exerciseName: "Pogo Jumps", dateRecorded: todayDate, lengthSecondsMin: 120, lengthSecondsMax: 180),
            TrainingKPI(exerciseName: "Hold Iso Lunge", dateRecorded: todayDate, lengthSecondsMin: 120, lengthSecondsMax: 180),
            TrainingKPI(exerciseName: "Hip Thrust - Bar", dateRecorded: todayDate, bodyWeightMultiplierMin: 1.5, bodyWeightMultiplierMax: 2.0, repsMin: 3, repsMax: 8, weightRangeDescription: "Past 360–400 lbs"),
            TrainingKPI(exerciseName: "Split Squat", dateRecorded: todayDate, bodyWeightMultiplierMin: 1.35, bodyWeightMultiplierMax: 1.5),
            TrainingKPI(exerciseName: "Hip Flexor Strength - Cable", dateRecorded: todayDate, bodyWeightMultiplierMin: 0.3, bodyWeightMultiplierMax: 0.5, repsMin: 8, repsMax: 15),
            TrainingKPI(exerciseName: "DB Press", dateRecorded: todayDate, bodyWeightMultiplierMin: 1.4, bodyWeightMultiplierMax: 1.6, repsMin: 6, repsMax: 10, weightRangeDescription: "65–100 lbs")
        ]

        for kpi in sampleKPIs {
            context.insert(kpi)
        }

        let weightRecord = WeightRecord(weight: 188.0, dateRecorded: todayDate)
        context.insert(weightRecord)

        do { try context.save(); print("kpis saved") } catch {}
    }

    func deleteAllKPIs(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<TrainingKPI>()

        do {
            let allKPIs = try modelContext.fetch(descriptor)
            for kpi in allKPIs {
                modelContext.delete(kpi)
            }
            try modelContext.save()
            print("Deleted all TrainingKPI records.")
        } catch {
            print("Failed to delete KPIs:", error)
        }
    }

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
                            case .kpi:
                                KPIListView()
                            case .kpiDetails:
                                KPIDetailsView()
                            default:
                                EmptyView()
                            }
                        }
                }
            }
            .padding([.leading, .trailing], 16)
        }
        .onAppear {
            print("ContentView loaded saved phase: \(phaseManager.phaseRecord?.description)")

            // Set the initial phase data on the screen

            if let phaseRecord = phaseManager.phaseRecord {
                viewModel.currentPhase = phaseRecord.phaseName
                viewModel.currentWeek = phaseRecord.phaseWeek
                viewModel.currentDay = phaseRecord.phaseDay
                viewModel.lastCompletedItem = phaseRecord.lastCompletedItem
                viewModel.weeks = Array(1 ..< phaseRecord.phaseWeekTotal + 1)
                viewModel.completedDayAccelerationExercises = phaseRecord.completedDayAccelerationExercises
                viewModel.completedDayConditioningExercises = phaseRecord.completedDayConditioningExercises
                viewModel.completedDayAccelerationExercises = phaseRecord.completedDayAccelerationExercises

            } else {
//                selectedPhase = "Postseason"
//                selectedWeek = 1
//                selectedDay = "Monday"
            }

            fetchKPIs()
        }
        .onChange(of: viewModel.pickingPhase) { _ in
//            print("pickingPhase to: \(newValue)")
        }
        .onChange(of: phaseManager.phaseRecord) { record in
            print("ContentView phaseInfo changed to: \(record)")
        }
        .tint(AppConfig.greenColor)
        .environmentObject(viewModel)
//        .deleteAllKPIs(modelContext: modelContext)

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
