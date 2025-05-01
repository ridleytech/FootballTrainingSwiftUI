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

    @State var selectedPhase: String = "Postseason"
    @State var selectedWeek: Int = 1
    @State var selectedDay: String = "Monday"
    @State var lastCompletedItem: Int = 0

    @State private var phases = ["Postseason", "Winter", "Spring", "Summer", "Preseason", "In-Season"]
    @State private var weeks = [1, 2, 3, 4, 5, 6, 7]
    @State private var days = ["Monday", "Tuesday", "Thursday", "Friday"]
    @State private var pickingPhase = false

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
        NavigationStack(path: $navigationManager.path) {
            VStack {
                Spacer()
                    .frame(height: 50)

                ZStack {
                    Spacer()

                    Text("Football Training")
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .foregroundColor(AppConfig.greenColor)

                    HStack {
                        Spacer()
                        Button(action: {
                            pickingPhase.toggle()

                        }) {
                            Text("P")
                                .font(.system(size: 16, weight: .bold, design: .default))
                                //                        .frame(maxWidth: .infinity)
                                .frame(width: 25, height: 25)
                                .background(Color(hex: "7FBF30"))
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                    }
                }

                if pickingPhase {
                    let pickerHeight: CGFloat = 200

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
                    //                .background(Color.red)

                    Spacer()
                } else {
                    BaseScreen(
                        currentPhase: $selectedPhase,
                        currentDay: $selectedDay,
                        currentWeek: $selectedWeek,
                        lastCompletedItem: $lastCompletedItem
                    )
                }
            }
            .padding([.leading, .trailing], 16)
        }
        .onAppear {
            if let record = phaseManager.phaseRecord {
                selectedPhase = record.phaseName
                selectedWeek = record.phaseWeek
                selectedDay = record.phaseDay
                lastCompletedItem = record.lastCompletedItem
                getPhaseData()
            }
        }
        .onChange(of: pickingPhase) { _ in
//            print("pickingPhase to: \(newValue)")
        }
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
