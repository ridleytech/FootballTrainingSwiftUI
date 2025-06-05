//
//  EditTrainingKPIView.swift
//  FootballTraining
//
//  Created by Randall Ridley on 6/4/25.
//

import SwiftUI

struct TrainingKPIFormView: View {
    @Environment(\.modelContext) private var modelContext

    @Binding var kpi: TrainingKPI
    @State private var exerciseName: String
    @State private var bodyWeightMultiplierMin: String
    @State private var bodyWeightMultiplierMax: String
    @State private var repsMin: String
    @State private var repsMax: String
    @State private var liftSpeedConcentricMin: String
    @State private var liftSpeedConcentricMax: String
    @State private var liftSpeedEccentric: String
    @State private var lengthSecondsMin: String
    @State private var lengthSecondsMax: String
    @State private var weightRangeDescription: String
    @State private var notes: String
    @State private var currentProgress: String
    @State private var targetGoal: String

    // Placeholder initializer for creating a new KPI
    init(kpi: Binding<TrainingKPI>) {
        _kpi = kpi
        _exerciseName = State(initialValue: kpi.wrappedValue.exerciseName)
        _bodyWeightMultiplierMin = State(initialValue: kpi.wrappedValue.bodyWeightMultiplierMin?.description ?? "")
        _bodyWeightMultiplierMax = State(initialValue: kpi.wrappedValue.bodyWeightMultiplierMax?.description ?? "")
        _repsMin = State(initialValue: kpi.wrappedValue.repsMin?.description ?? "")
        _repsMax = State(initialValue: kpi.wrappedValue.repsMax?.description ?? "")
        _liftSpeedConcentricMin = State(initialValue: kpi.wrappedValue.liftSpeedConcentricMin?.description ?? "")
        _liftSpeedConcentricMax = State(initialValue: kpi.wrappedValue.liftSpeedConcentricMax?.description ?? "")
        _liftSpeedEccentric = State(initialValue: kpi.wrappedValue.liftSpeedEccentric?.description ?? "")
        _lengthSecondsMin = State(initialValue: kpi.wrappedValue.lengthSecondsMin?.description ?? "")
        _lengthSecondsMax = State(initialValue: kpi.wrappedValue.lengthSecondsMax?.description ?? "")
        _weightRangeDescription = State(initialValue: kpi.wrappedValue.weightRangeDescription ?? "")
        _notes = State(initialValue: kpi.wrappedValue.notes ?? "")
        _currentProgress = State(initialValue: kpi.wrappedValue.currentProgress ?? "")
        _targetGoal = State(initialValue: kpi.wrappedValue.targetGoal ?? "")
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
                kpi.exerciseName = exerciseName
                kpi.bodyWeightMultiplierMin = Double(bodyWeightMultiplierMin)
                kpi.bodyWeightMultiplierMax = Double(bodyWeightMultiplierMax)
                kpi.repsMin = Int(repsMin)
                kpi.repsMax = Int(repsMax)
                kpi.liftSpeedConcentricMin = Double(liftSpeedConcentricMin)
                kpi.liftSpeedConcentricMax = Double(liftSpeedConcentricMax)
                kpi.liftSpeedEccentric = Double(liftSpeedEccentric)
                kpi.lengthSecondsMin = Int(lengthSecondsMin)
                kpi.lengthSecondsMax = Int(lengthSecondsMax)
                kpi.weightRangeDescription = weightRangeDescription
                kpi.notes = notes
                kpi.currentProgress = currentProgress
                kpi.targetGoal = targetGoal
            }
        }
        .navigationTitle("Create/Edit KPI")
        .onAppear {
            let mm = MaxManager(modelContext: modelContext)

            if let weight = mm.weightRecord?.weight {
                kpi.calculateTargetGoal(weight: weight)

                if let kpiTargetGoal = kpi.targetGoal {
//                    print("range: \(kpiTargetGoal)")

                    targetGoal = kpiTargetGoal
                }
            }
        }
    }
}

struct EditKPIView: View {
    @State private var kpi = TrainingKPI(
        exerciseName: "Squat", dateRecorded: Date(), bodyWeightMultiplierMin: 1.5, bodyWeightMultiplierMax: 2.0
    )

    var body: some View {
        NavigationView {
            TrainingKPIFormView(kpi: $kpi)
        }
    }
}

struct TrainingKPIFormView_Previews: PreviewProvider {
    static var previews: some View {
        EditKPIView()
    }
}
