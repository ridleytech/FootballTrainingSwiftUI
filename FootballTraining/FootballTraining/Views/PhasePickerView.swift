//
//  PhasePickerView.swift
//  FootballTraining
//
//  Created by Randall Ridley on 5/1/25.
//

import _SwiftData_SwiftUI
import Foundation
import SwiftUI

struct PhasePickerView: View {
    @EnvironmentObject var phaseManager: PhaseManager
    @EnvironmentObject var viewModel: PhaseViewModel

    let pickerHeight: CGFloat = 200

    func getPhaseData() {
        do {
            if let url = Bundle.main.url(forResource: viewModel.currentPhase, withExtension: "json"),
               let data = try? Data(contentsOf: url),
               let currentPhaseData = try? JSONDecoder().decode(PhaseModel.self, from: data)
            {
                viewModel.weeks = Array(1 ..< currentPhaseData.week.count + 1)
            }
        } catch {
            print("Failed to fetch all records:", error)
        }
    }

    func phaseChanged(to newPhase: String) {
        print("Phase changed to: \(newPhase)")
        viewModel.currentWeek = 1
        viewModel.completedDayAccelerationExercises = []
        viewModel.completedDayConditioningExercises = []
        viewModel.completedDayExercises = []
        viewModel.skippedExercises = .init(exercises: [], date: Date())

        getPhaseData()

        phaseManager.update(
            phaseName: newPhase,
            phaseWeek: viewModel.currentWeek,
            phaseDay: viewModel.currentDay,
            phaseWeekTotal: viewModel.weeks.count,
            completedDayExercises: viewModel.completedDayExercises,
            completedDayConditioningExercises: viewModel.completedDayConditioningExercises,
            completedDayAccelerationExercises: viewModel.completedDayAccelerationExercises,
            skippedExercises: viewModel.skippedExercises
        )
    }

    func weekChanged(to newWeek: Int) {
        print("Week changed to: \(newWeek)")

        viewModel.completedDayAccelerationExercises = []
        viewModel.completedDayConditioningExercises = []
        viewModel.completedDayExercises = []
        viewModel.skippedExercises = .init(exercises: [], date: Date())

        phaseManager.update(
            phaseName: viewModel.currentPhase,
            phaseWeek: newWeek,
            phaseDay: viewModel.currentDay,
            phaseWeekTotal: viewModel.weeks.count,
            completedDayExercises: viewModel.completedDayExercises,
            completedDayConditioningExercises: viewModel.completedDayConditioningExercises,
            completedDayAccelerationExercises: viewModel.completedDayAccelerationExercises,
            skippedExercises: viewModel.skippedExercises
        )
    }

    func dayChanged(to newDay: String) {
        print("Day changed to: \(newDay)")

        viewModel.completedDayAccelerationExercises = []
        viewModel.completedDayConditioningExercises = []
        viewModel.completedDayExercises = []

        phaseManager.update(
            phaseName: viewModel.currentPhase,
            phaseWeek: viewModel.currentWeek,
            phaseDay: newDay,
            phaseWeekTotal: viewModel.weeks.count,
            completedDayExercises: viewModel.completedDayExercises,
            completedDayConditioningExercises: viewModel.completedDayConditioningExercises,
            completedDayAccelerationExercises: viewModel.completedDayAccelerationExercises,
            skippedExercises: viewModel.skippedExercises
        )
    }

    var body: some View {
        VStack {
            Spacer().frame(height: 10)
            Text("Select Phase")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(AppConfig.grayColor)

            Picker("Select Phase", selection: $viewModel.currentPhase) {
                ForEach(viewModel.phases, id: \.self) { phase in
                    Text(phase)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: pickerHeight)
            // .background(Color.yellow)
            .onChange(of: viewModel.currentPhase) { newPhase in
                phaseChanged(to: newPhase)
            }

            Picker("Select Week", selection: $viewModel.currentWeek) {
                ForEach(viewModel.weeks, id: \.self) { week in
                    Text("Week \(week)")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: pickerHeight)
            //                    .background(Color.green)
            .onChange(of: viewModel.currentWeek) { newWeek in
                weekChanged(to: newWeek)
            }

            Picker("Select Day", selection: $viewModel.currentDay) {
                ForEach(viewModel.days, id: \.self) { day in
                    Text("\(day)")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: pickerHeight)
            // .background(Color.green)
            .onChange(of: viewModel.currentDay) { newDay in
                dayChanged(to: newDay)
            }
        }
        .onAppear {
            if let record = phaseManager.phaseRecord {
                viewModel.currentPhase = record.phaseName
                viewModel.currentWeek = record.phaseWeek
                viewModel.currentDay = record.phaseDay
//                getPhaseData()
            }
        }
    }
}

struct PhasePickerView_Previews: PreviewProvider {
    static var previews: some View {
        // 1. Create an in-memory SwiftData model container
        let schema = Schema([
            Item.self,
            MaxIntensityRecord.self,
            PhaseRecord.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])

        // 3. Use a context from the model container to create the PhaseManager
        return ModelContextPreview(container: container) { modelContext in
            let phaseManager = PhaseManager(modelContext: modelContext)

            return PhasePickerView()
                .environmentObject(phaseManager)
                .environmentObject(PhaseViewModel())
        }
        .modelContainer(container)
    }
}
