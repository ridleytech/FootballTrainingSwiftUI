//
//  SaveMax.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import SwiftData
import SwiftUI

struct SaveMax: View {
    @Binding var selectedExercise: DayExercises
    @Binding var maxDataChanged: Bool
    @State var intensity: String = ""
    @Environment(\.modelContext) private var modelContext
    @State private var records: [MaxIntensityRecord] = []
    @FocusState private var isKeyboardFocused: Bool
    @State private var showSaveDecisionAlert = false
    @State private var showMaxSavedAlert = false
    @State private var recentRecord: MaxIntensityRecord?
    @State private var pendingIntensity: Double?

    private func loadExerciseRecords() {
        let exerciseName = selectedExercise.name // ✅ capture value first

        let descriptor = FetchDescriptor<MaxIntensityRecord>(
            predicate: #Predicate { $0.exerciseName == exerciseName },
            sortBy: [SortDescriptor(\.dateRecorded, order: .forward)]
        )

        do {
            records = try modelContext.fetch(descriptor)
            if let latest = records.last {
                intensity = String(format: "%.0f", latest.maxIntensity)
            }
        } catch {
            print("Failed to fetch records:", error)
        }
    }

    func attemptSaveMaxIntensity(exerciseName: String, intensity: Double, context: ModelContext) {
        var descriptor = FetchDescriptor<MaxIntensityRecord>(
            predicate: #Predicate { $0.exerciseName == exerciseName },
            sortBy: [SortDescriptor(\.dateRecorded, order: .reverse)]
        )
        descriptor.fetchLimit = 1

        do {
            if let latest = try context.fetch(descriptor).first,
               let days = Calendar.current.dateComponents([.day], from: latest.dateRecorded, to: Date()).day,
               days < 2
            {
                recentRecord = latest
                pendingIntensity = intensity
                showSaveDecisionAlert = true
                return
            }
        } catch {
            print("Failed to fetch latest record:", error)
        }

        saveNewMaxIntensity(exerciseName: exerciseName, intensity: intensity, context: context)
    }

    func saveNewMaxIntensity(exerciseName: String, intensity: Double, context: ModelContext) {
//        let testDate = Date().addingTimeInterval(86400 * 10) // 3 days in the future
        let todayDate = Date()

        let record = MaxIntensityRecord(exerciseName: exerciseName, maxIntensity: intensity, dateRecorded: todayDate)
        context.insert(record)

        do {
            try context.save()
            selectedExercise.max = intensity
            showMaxSavedAlert = true
            maxDataChanged = true
            loadExerciseRecords()
        } catch {
            print("Failed to save new record:", error)
        }

        UIApplication.shared.endEditing()
    }

    func updateRecentMaxIntensity(context: ModelContext) {
        guard let record = recentRecord, let newIntensity = pendingIntensity, let dateRecorded = recentRecord?.dateRecorded else { return }

//        let yesterday = Date().addingTimeInterval(-(86400 / 2))

        record.maxIntensity = newIntensity
        record.dateRecorded = dateRecorded

        do {
            try context.save()
            selectedExercise.max = newIntensity
            showMaxSavedAlert = true
            maxDataChanged = true
            loadExerciseRecords()
        } catch {
            print("Failed to update record:", error)
        }

        UIApplication.shared.endEditing()
    }

    var body: some View {
        VStack {
            Text("\(selectedExercise.name)")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(AppConfig.greenColor)

            Spacer().frame(height: 3)

            Text("1 (Rep Max)")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppConfig.greenColor)

            Spacer().frame(height: 10)

            VStack(spacing: 20) {
                TextField("Max Amount", text: $intensity)
                    .keyboardType(.numberPad)
                    .focused($isKeyboardFocused)
                    .padding(10)
                    .background(Color(hex: "F0F0F0"))

                Spacer()

                Button("Save Max") {
                    if let intensityValue = Double(intensity) {
                        attemptSaveMaxIntensity(
                            exerciseName: selectedExercise.name,
                            intensity: intensityValue,
                            context: modelContext
                        )
                    }
                }
                .font(.system(size: 16, weight: .bold))
                .frame(maxWidth: .infinity, minHeight: 45)
                .background(Color(hex: "7FBF30"))
                .foregroundColor(.white)
                .cornerRadius(5)
            }
        }
        .padding([.leading, .trailing], 16)
        // ✅ Move toolbar to top-level VStack to avoid ambiguity
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isKeyboardFocused = false
                }
            }
        }
        .alert("Max Saved", isPresented: $showMaxSavedAlert) {
            Button("Ok") {}
        }
        .alert("A max intensity was already saved recently. What do you want to do?", isPresented: $showSaveDecisionAlert) {
            Button("Update Existing", role: .destructive) {
                updateRecentMaxIntensity(context: modelContext)
            }
            Button("Save New Record") {
                if let newIntensity = pendingIntensity {
                    saveNewMaxIntensity(exerciseName: selectedExercise.name, intensity: newIntensity, context: modelContext)
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .onAppear {
            loadExerciseRecords()
        }
    }
}

#Preview {
    // 1. Create State values for the preview
    @State var exerciseName = "Bench Press"
    @State var intensity = "300"

    // 2. Return the view with Bindings and SwiftData modelContainer
    SaveMax(selectedExercise: .constant(DayExercises(text: "String", type: "String", name: "String", sets: [], max: 1.0)), maxDataChanged: .constant(false), intensity: intensity)
//        .modelContainer(for: MaxIntensityRecord.self, inMemory: true)
        .modelContainer(for: MaxIntensityRecord.self)
}
