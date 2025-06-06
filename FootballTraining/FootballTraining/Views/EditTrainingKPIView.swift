//
//  EditTrainingKPIView.swift
//  FootballTraining
//
//  Created by Randall Ridley on 6/4/25.
//

import SwiftUI

struct KPIDetailsView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var viewModel: PhaseViewModel

    @State private var exerciseName: String = ""
    @State private var bodyWeightMultiplierMin: String = ""
    @State private var bodyWeightMultiplierMax: String = ""
    @State private var repsMin: String = ""
    @State private var repsMax: String = ""
    @State private var liftSpeedConcentricMin: String = ""
    @State private var liftSpeedConcentricMax: String = ""
    @State private var liftSpeedEccentric: String = ""
    @State private var lengthSecondsMin: String = ""
    @State private var lengthSecondsMax: String = ""
    @State private var weightRangeDescription: String = ""
    @State private var notes: String = ""
    @State private var currentProgress: String = ""
    @State private var targetGoal: String = ""

    // Placeholder initializer for creating a new KPI
    func mapKPIData() {
        let kpi = viewModel.selectedKPI

        exerciseName = kpi.exerciseName
        bodyWeightMultiplierMin = kpi.bodyWeightMultiplierMin?.description ?? ""
        bodyWeightMultiplierMax = kpi.bodyWeightMultiplierMax?.description ?? ""
        repsMin = kpi.repsMin?.description ?? ""
        repsMax = kpi.repsMax?.description ?? ""
        liftSpeedConcentricMin = kpi.liftSpeedConcentricMin?.description ?? ""
        liftSpeedConcentricMax = kpi.liftSpeedConcentricMax?.description ?? ""
        liftSpeedEccentric = kpi.liftSpeedEccentric?.description ?? ""
        lengthSecondsMin = kpi.lengthSecondsMin?.description ?? ""
        lengthSecondsMax = kpi.lengthSecondsMax?.description ?? ""
        weightRangeDescription = kpi.weightRangeDescription ?? ""
        notes = kpi.notes ?? ""
        currentProgress = kpi.currentProgress ?? ""
        targetGoal = kpi.targetGoal ?? ""
    }

    var body: some View {
        Form {
            Section(header: Text("Training KPI")) {
                // Exercise Name
                VStack(alignment: .leading) {
                    if !exerciseName.isEmpty {
                        Text("Exercise Name")
                            .font(.headline)
                    }
                    TextField("Exercise Name", text: $exerciseName)
                }

                // Body Weight Multiplier Min
                VStack(alignment: .leading) {
                    if !bodyWeightMultiplierMin.isEmpty {
                        Text("Body Weight Multiplier Min")
                            .font(.headline)
                    }
                    TextField("Body Weight Multiplier Min", text: $bodyWeightMultiplierMin)
                        .keyboardType(.decimalPad)
                }

                // Body Weight Multiplier Max
                VStack(alignment: .leading) {
                    if !bodyWeightMultiplierMax.isEmpty {
                        Text("Body Weight Multiplier Max")
                            .font(.headline)
                    }
                    TextField("Body Weight Multiplier Max", text: $bodyWeightMultiplierMax)
                        .keyboardType(.decimalPad)
                }

                // Reps Min
                VStack(alignment: .leading) {
                    if !repsMin.isEmpty {
                        Text("Reps Min")
                            .font(.headline)
                    }
                    TextField("Reps Min", text: $repsMin)
                        .keyboardType(.numberPad)
                }

                // Reps Max
                VStack(alignment: .leading) {
                    if !repsMax.isEmpty {
                        Text("Reps Max")
                            .font(.headline)
                    }
                    TextField("Reps Max", text: $repsMax)
                        .keyboardType(.numberPad)
                }

                // Lift Speed Concentric Min
                VStack(alignment: .leading) {
                    if !liftSpeedConcentricMin.isEmpty {
                        Text("Lift Speed Concentric Min")
                            .font(.headline)
                    }
                    TextField("Lift Speed Concentric Min", text: $liftSpeedConcentricMin)
                        .keyboardType(.decimalPad)
                }

                // Lift Speed Concentric Max
                VStack(alignment: .leading) {
                    if !liftSpeedConcentricMax.isEmpty {
                        Text("Lift Speed Concentric Max")
                            .font(.headline)
                    }
                    TextField("Lift Speed Concentric Max", text: $liftSpeedConcentricMax)
                        .keyboardType(.decimalPad)
                }

                // Lift Speed Eccentric
                VStack(alignment: .leading) {
                    if !liftSpeedEccentric.isEmpty {
                        Text("Lift Speed Eccentric")
                            .font(.headline)
                    }
                    TextField("Lift Speed Eccentric", text: $liftSpeedEccentric)
                        .keyboardType(.decimalPad)
                }

                // Length (Seconds) Min
                VStack(alignment: .leading) {
                    if !lengthSecondsMin.isEmpty {
                        Text("Length (Seconds) Min")
                            .font(.headline)
                    }
                    TextField("Length (Seconds) Min", text: $lengthSecondsMin)
                        .keyboardType(.numberPad)
                }

                // Length (Seconds) Max
                VStack(alignment: .leading) {
                    if !lengthSecondsMax.isEmpty {
                        Text("Length (Seconds) Max")
                            .font(.headline)
                    }
                    TextField("Length (Seconds) Max", text: $lengthSecondsMax)
                        .keyboardType(.numberPad)
                }

                // Weight Range Description
                VStack(alignment: .leading) {
                    if !weightRangeDescription.isEmpty {
                        Text("Weight Range Description")
                            .font(.headline)
                    }
                    TextField("Weight Range Description", text: $weightRangeDescription)
                }

                // Notes
                VStack(alignment: .leading) {
                    if !notes.isEmpty {
                        Text("Notes")
                            .font(.headline)
                    }
                    TextField("Notes", text: $notes)
                }

                // Current Progress
                VStack(alignment: .leading) {
                    if !currentProgress.isEmpty {
                        Text("Current Progress")
                            .font(.headline)
                    }
                    TextField("Current Progress", text: $currentProgress)
                }

                // Target Goal
                VStack(alignment: .leading) {
                    if !targetGoal.isEmpty {
                        Text("Target Goal")
                            .font(.headline)
                    }
                    TextField("Target Goal", text: $targetGoal)
                }
            }

            Button("Save KPI") {
                // Save or update the KPI model
                viewModel.selectedKPI.exerciseName = exerciseName
                viewModel.selectedKPI.bodyWeightMultiplierMin = Double(bodyWeightMultiplierMin)
                viewModel.selectedKPI.bodyWeightMultiplierMax = Double(bodyWeightMultiplierMax)
                viewModel.selectedKPI.repsMin = Int(repsMin)
                viewModel.selectedKPI.repsMax = Int(repsMax)
                viewModel.selectedKPI.liftSpeedConcentricMin = Double(liftSpeedConcentricMin)
                viewModel.selectedKPI.liftSpeedConcentricMax = Double(liftSpeedConcentricMax)
                viewModel.selectedKPI.liftSpeedEccentric = Double(liftSpeedEccentric)
                viewModel.selectedKPI.lengthSecondsMin = Int(lengthSecondsMin)
                viewModel.selectedKPI.lengthSecondsMax = Int(lengthSecondsMax)
                viewModel.selectedKPI.weightRangeDescription = weightRangeDescription
                viewModel.selectedKPI.notes = notes
                viewModel.selectedKPI.currentProgress = currentProgress

                if targetGoal != "N/A" {
                    viewModel.selectedKPI.targetGoal = targetGoal
                }

                // to do: give option to update or save new KPI

                if !currentProgress.isEmpty {
                    let kpiProgress = KPIProgress(weight: Double(currentProgress)!, exercise: exerciseName, dateRecorded: Date())

                    modelContext.insert(kpiProgress)
                }

//                modelContext.save()
            }
        }
        .navigationTitle("Create/Edit KPI")
        .onAppear {
            let mm = MaxManager(modelContext: modelContext)

            mapKPIData()

            if let weight = mm.weightRecord?.weight {
                print("current weight: \(weight)")

                targetGoal = viewModel.selectedKPI.calculateTargetGoal(weight: weight)

//                if let kpiTargetGoal = viewModel.selectedKPI.targetGoal {
                ////                    print("range: \(kpiTargetGoal)")
//
//                    targetGoal = kpiTargetGoal
//                }
            }
        }
    }
}

struct TrainingKPIFormView_Previews: PreviewProvider {
    static var previews: some View {
        KPIDetailsView()
    }
}
