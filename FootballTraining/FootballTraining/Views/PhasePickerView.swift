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
    @Binding var selectedPhase: String
    @Binding var selectedWeek: Int
    @Binding var selectedDay: String
    @Binding var lastCompletedItem: Int
    @Binding var phases: [String]
    @Binding var days: [String]
    @Binding var weeks: [Int]

    let pickerHeight: CGFloat = 200

//    @Binding private var phases = ["Postseason", "Winter", "Spring", "Summer", "Preseason", "In-Season"]
//    @Binding private var weeks = [1, 2, 3, 4, 5, 6, 7]
//    @Binding private var days = ["Monday", "Tuesday", "Thursday", "Friday"]
//    @Binding private var pickerHeight: CGFloat = 200
//    @State private var pickingPhase = false
//    @State private var phaseChanged = false
//    @State private var weekChanged = false
//    @State private var dayChanged = false
//    @State private var phaseChangedTo: String = ""

    func getPhaseData() {
        do {
            if let url = Bundle.main.url(forResource: selectedPhase, withExtension: "json"),
               let data = try? Data(contentsOf: url),
               let postseason = try? JSONDecoder().decode(PostseasonModel.self, from: data)
            {
                weeks = Array(1 ..< postseason.week.count)
            }
        } catch {
            print("Failed to fetch all records:", error)
        }
    }

    func phaseChanged(to newPhase: String) {
        print("Phase changed to: \(newPhase)")
        selectedWeek = 1
        lastCompletedItem = 0

        getPhaseData()

        phaseManager.update(
            phaseName: newPhase,
            phaseWeek: selectedWeek,
            phaseDay: selectedDay,
            lastCompletedItem: lastCompletedItem,
            phaseWeekTotal: weeks.count
        )
    }

    func weekChanged(to newWeek: Int) {
        print("Week changed to: \(newWeek)")
        phaseManager.update(
            phaseName: selectedPhase,
            phaseWeek: newWeek,
            phaseDay: selectedDay,
            lastCompletedItem: lastCompletedItem,
            phaseWeekTotal: weeks.count
        )
    }

    func dayChanged(to newDay: String) {
        print("Day changed to: \(newDay)")

        lastCompletedItem = 0

        phaseManager.update(
            phaseName: selectedPhase,
            phaseWeek: selectedWeek,
            phaseDay: newDay,
            lastCompletedItem: lastCompletedItem,
            phaseWeekTotal: weeks.count
        )
    }

    var body: some View {
        VStack {
            Spacer().frame(height: 10)
            Text("Select Phase")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(AppConfig.grayColor)

            Picker("Select Phase", selection: $selectedPhase) {
                ForEach(phases, id: \.self) { phase in
                    Text(phase)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: pickerHeight)
            //                    .background(Color.yellow)
            .onChange(of: selectedPhase) { newPhase in
                phaseChanged(to: newPhase)
            }

            Picker("Select Week", selection: $selectedWeek) {
                ForEach(weeks, id: \.self) { week in
                    Text("Week \(week)")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: pickerHeight)
            //                    .background(Color.green)
            .onChange(of: selectedWeek) { newWeek in
                weekChanged(to: newWeek)
            }

            Picker("Select Day", selection: $selectedDay) {
                ForEach(days, id: \.self) { day in
                    Text("\(day)")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: pickerHeight)
            //                    .background(Color.green)
            .onChange(of: selectedDay) { newDay in
                dayChanged(to: newDay)
            }
        }
        .onAppear {
            if let record = phaseManager.phaseRecord {
                selectedPhase = record.phaseName
                selectedWeek = record.phaseWeek
                selectedDay = record.phaseDay
                lastCompletedItem = record.lastCompletedItem
//                getPhaseData()
            }
        }
    }
}

#Preview {
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

        return NavigationStack {
            PhasePickerView(
                selectedPhase: .constant("Postseason"),
                selectedWeek: .constant(1),
                selectedDay: .constant("Monday"),
                lastCompletedItem: .constant(0),
                phases: .constant(["Postseason", "Winter", "Spring", "Summer", "Preseason", "In-Season"]),
                days: .constant(["Monday", "Tuesday", "Thursday", "Friday"]),
                weeks: .constant([1, 2, 3, 4, 5, 6, 7])
            )
            //        .modelContainer(for: Item.self, inMemory: true)
            .modelContainer(for: MaxIntensityRecord.self)
            .environmentObject(NavigationManager())
            .environmentObject(phaseManager)
        }
    }
    .modelContainer(container)
}
