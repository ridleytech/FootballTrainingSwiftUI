//
//  MaxHistory.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import _SwiftData_SwiftUI
import Charts
import SwiftUI

struct MaxHistoryView: View {
    @Binding var exerciseName: String
    @Environment(\.modelContext) private var modelContext
    @State private var allRecords: [MaxIntensityRecord] = []
    @State private var records: [MaxIntensityRecord] = []
    @State var gotoToSaveMax = false

    private func loadAllRecords() {
        let descriptor = FetchDescriptor<MaxIntensityRecord>(
            sortBy: [SortDescriptor(\.dateRecorded, order: .forward)]
        )

        do {
            allRecords = try modelContext.fetch(descriptor)

            print("all records: \(allRecords)")
        } catch {
            print("Failed to fetch all records:", error)
        }
    }

    private func loadExerciseRecords() {
        print("loadExerciseRecords")

        let descriptor = FetchDescriptor<MaxIntensityRecord>(
            predicate: #Predicate { $0.exerciseName == exerciseName },
            sortBy: [SortDescriptor(\.dateRecorded, order: .forward)]
        )

        do {
            records = try modelContext.fetch(descriptor)

            print("exercise records: \(records)")

            if let latest = records.last {
                print("Latest Bench Press Max: \(latest.maxIntensity) lbs")
            }

        } catch {
            print("Failed to fetch records:", error)
        }
    }

    var body: some View {
        VStack {
            Text(exerciseName)
                .font(.system(size: 18, weight: .bold, design: .default))
                .foregroundColor(AppConfig.greenColor)

            HStack {
                Spacer()

                Button("+ Add Max") {
                    gotoToSaveMax = true
                }
                .font(.system(size: 16, weight: .bold, design: .default))
                .foregroundColor(AppConfig.greenColor)
            }

            Spacer()

            if records.isEmpty {
                Text("No \(exerciseName) records.")
                    .foregroundColor(.gray)
            } else {
                Chart(records) { record in
                    LineMark(
                        x: .value("Date", record.dateRecorded),
                        y: .value("Max Weight", record.maxIntensity)
                    )
                    .symbol(Circle())
                }
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        if let dateValue = value.as(Date.self) {
                            AxisGridLine()
                            AxisValueLabel {
                                Text(dateValue, format: .dateTime.month().day().year())
                                    .font(.caption)
                            }
                        }
                    }
                }
                .chartYAxisLabel("Weight (lbs)")
                .chartXAxisLabel("Date")
                .frame(height: 300)
                .padding()
            }

            Spacer()
        }
        .padding([.leading, .trailing], 16)
        .onAppear {
            loadExerciseRecords()
            loadAllRecords()
        }
        .navigationDestination(isPresented: $gotoToSaveMax) {
            SaveMax(exerciseName: $exerciseName)
        }
//        .navigationTitle("\(exerciseName) History")
    }
}

#Preview {
    MaxHistoryView(exerciseName: .constant("Bench Press"))
}
