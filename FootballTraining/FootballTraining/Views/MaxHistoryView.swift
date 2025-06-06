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
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var viewModel: PhaseViewModel
    @Environment(\.modelContext) private var modelContext
//    @State private var allRecords: [MaxIntensityRecord] = []
    @State private var records: [MaxIntensityRecord] = []
    @State var gotoToSaveMax = false
    @State private var selectedRecord: MaxIntensityRecord?
    @State private var animatedRecords: [MaxIntensityRecord] = []
    @State private var chartVisible = false

//    private func loadAllRecords() {
//        let descriptor = FetchDescriptor<MaxIntensityRecord>(
//            sortBy: [SortDescriptor(\.dateRecorded, order: .forward)]
//        )
//
//        do {
//            allRecords = try modelContext.fetch(descriptor)
//
//            print("all records: \(allRecords)")
//        } catch {
//            print("Failed to fetch all records:", error)
//        }
//    }

    private func loadExerciseRecords() {
        print("loadExerciseRecords")

        let exerciseName = viewModel.selectedExercise.name

        let descriptor = FetchDescriptor<MaxIntensityRecord>(
            predicate: #Predicate { $0.exerciseName == exerciseName },
            sortBy: [SortDescriptor(\.dateRecorded, order: .forward)]
        )

        do {
            records = try modelContext.fetch(descriptor)

            print("exercise records: \(records)")

            if let latest = records.last {
                print("Latest \(exerciseName) Max: \(latest.maxIntensity) lbs")
            }

        } catch {
            print("Failed to fetch records:", error)
        }
    }

    var body: some View {
        VStack {
            Text(viewModel.selectedExercise.name)
                .font(.system(size: 18, weight: .bold, design: .default))
                .foregroundColor(AppConfig.greenColor)

            Spacer()

            if records.isEmpty {
                Text("No \(viewModel.selectedExercise.name) records.")
                    .foregroundColor(.gray)
            } else {
                if chartVisible {
                    Chart(animatedRecords) { record in
                        LineMark(
                            x: .value("Date", record.dateRecorded),
                            y: .value("Max", record.maxIntensity)
                        )
                        .interpolationMethod(.catmullRom)
                        .symbol(Circle())

                        if selectedRecord?.dateRecorded == record.dateRecorded {
                            PointMark(
                                x: .value("Date", record.dateRecorded),
                                y: .value("Max", record.maxIntensity)
                            )
                            .annotation(position: .top) {
                                VStack(spacing: 2) {
                                    Text("\(Int(record.maxIntensity)) lbs")
                                    Text(record.dateRecorded.formatted(date: .numeric, time: .omitted))
                                }
                                .foregroundColor(Color.white)
                                .font(.caption2)
                                .padding(6)
                                .background(Color.black.opacity(0.8))
                                .cornerRadius(5)
                            }
                        }
                    }
                    .chartOverlay { proxy in
                        GeometryReader { _ in
                            Rectangle().fill(Color.clear).contentShape(Rectangle())
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            let location = value.location
                                            if let date: Date = proxy.value(atX: location.x) {
                                                if let nearest = animatedRecords.min(by: {
                                                    abs($0.dateRecorded.timeIntervalSince(date)) <
                                                        abs($1.dateRecorded.timeIntervalSince(date))
                                                }) {
                                                    selectedRecord = nearest
                                                }
                                            }
                                        }
                                )
                        }
                    }
                    .chartXAxis {
                        AxisMarks(values: .automatic) { value in
                            if let dateValue = value.as(Date.self) {
                                AxisGridLine()
                                AxisValueLabel {
                                    Text(dateValue.formatted(date: .abbreviated, time: .omitted))
                                        .font(.caption2)
                                }
                            }
                        }
                    }
                    .transition(.opacity)
                    .animation(.easeOut(duration: 1.0), value: chartVisible)
                    .padding(.top, 20)
                }
            }

            Spacer()

            Button(action: {
                navigationManager.path.append(Route2.saveMax)
            }) {
                Text("Add Max")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(Color(hex: "7FBF30"))
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
        }
        .padding([.leading, .trailing], 16)
        .onAppear {
            loadExerciseRecords()
//            loadAllRecords()
            animatedRecords = records
            chartVisible = true
        }

//        .navigationTitle("\(exerciseName) History")
    }
}

#Preview {
    MaxHistoryView(
        //        selectedExercise: .constant(DayExercise(text: "String", type: "String", name: "String", sets: [], max: 1.0))
    )
}
