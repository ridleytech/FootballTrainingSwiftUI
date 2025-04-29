//
//  SaveMax.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import SwiftData
import SwiftUI

struct SaveMax: View {
    @Binding var exerciseName: String
    @State var intensity: String = ""
    @Environment(\.modelContext) private var modelContext
    @State private var records: [MaxIntensityRecord] = []

    private func loadExerciseRecords() {
        print("loadExerciseRecords")

        let descriptor = FetchDescriptor<MaxIntensityRecord>(
            predicate: #Predicate { $0.exerciseName == exerciseName },
            sortBy: [SortDescriptor(\.dateRecorded, order: .forward)]
        )

        do {
            records = try modelContext.fetch(descriptor)

            if let latest = records.last {
                print("Latest Bench Press Max: \(latest.maxIntensity) lbs")
            }

        } catch {
            print("Failed to fetch records:", error)
        }
    }

    func saveMaxIntensity(exerciseName: String, intensity: Double, context: ModelContext) {
        let record = MaxIntensityRecord(exerciseName: exerciseName, maxIntensity: intensity, dateRecorded: Date())
        context.insert(record)

        do {
            try context.save()
            print("Saved \(exerciseName) with intensity \(intensity) on \(record.dateRecorded)")

            loadExerciseRecords()

        } catch {
            print("Failed to save:", error)
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            TextField("Exercise Name", text: $exerciseName)
                .textFieldStyle(.roundedBorder)

            TextField("Max Amount", text: $intensity)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.decimalPad)

            Spacer()

            Button(action: {
                if let intensityValue = Double(intensity) {
                    saveMaxIntensity(exerciseName: exerciseName, intensity: intensityValue, context: modelContext)
                }
            }) {
                Text("Save Max")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(Color(hex: "7FBF30"))
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            .padding([.leading, .trailing], 16)
            .onAppear {
                loadExerciseRecords()
            }
        }
        .padding()
    }
}

#Preview {
    // 1. Create State values for the preview
    @State var exerciseName = "Bench Press"
    @State var intensity = "300"

    // 2. Return the view with Bindings and SwiftData modelContainer
    SaveMax(exerciseName: $exerciseName, intensity: intensity)
//        .modelContainer(for: MaxIntensityRecord.self, inMemory: true)
        .modelContainer(for: MaxIntensityRecord.self)
}
