//
//  ModelUtls.swift
//  FootballTraining
//
//  Created by Randall Ridley on 5/1/25.
//

import Foundation
import SwiftData

class ModelUtils {
    static func getNextPhase(currentPhase: String, from options: [String]) -> String? {
        guard let currentIndex = options.firstIndex(of: currentPhase) else {
            return nil // currentPhase not found in options
        }

        let nextIndex = (currentIndex + 1) % options.count
        return options[nextIndex]
    }

    static func getNextDay(currentDay: String) -> String? {
        let days = ["Monday", "Tuesday", "Thursday", "Friday"]

        guard let currentIndex = days.firstIndex(of: currentDay) else {
            return nil // Invalid day
        }

        let nextIndex = (currentIndex + 1) % days.count
        return days[nextIndex]
    }

    static func savePhase(phaseOptions: [String], dayExerciseCount: Int, lastCompletedItem: inout Int,
                          currentPhase: inout String,
                          currentDay: inout String,
                          currentWeek: inout Int,
                          phaseManager: PhaseManager, modelContext: ModelContext)
    {
        print("savePhase CurrentDayWorkoutView")

        //            when day workout is finished,
        //            check if last exercise in day, if so, advance to next day, week, or phase

        do {
            if lastCompletedItem == dayExerciseCount {
                if currentDay == "Friday" {
                    if currentWeek == phaseManager.phaseRecord!.phaseWeekTotal {
                        print("go to next phase")

                        if let nextPhase = getNextPhase(currentPhase: currentPhase, from: phaseOptions) {
                            currentPhase = nextPhase
                            currentWeek = 1
                            currentDay = "Monday"
                            lastCompletedItem = 0
                            print("Next phase: \(currentPhase)")
                        }

                    } else {
                        currentWeek += 1
                        currentDay = "Monday"
                        lastCompletedItem = 0
                        print("go to next week")
                    }
                } else if let nextDay = getNextDay(currentDay: currentDay) {
                    currentDay = nextDay
                    lastCompletedItem = 0
                    print("Next day: \(currentDay)")
                }
            }

            phaseManager.update(phaseName: currentPhase, phaseWeek: currentWeek, phaseDay: currentDay, lastCompletedItem: lastCompletedItem, phaseWeekTotal: phaseManager.phaseRecord!.phaseWeekTotal)

//            print("Phase: \(phaseManager.phaseRecord?.phaseName)")

            var descriptor = FetchDescriptor<PhaseRecord>(
                predicate: #Predicate { $0.phaseName == currentPhase }
            )
            descriptor.fetchLimit = 1 // set fetchLimit separately

            let existingRecords = try modelContext.fetch(descriptor)

            if let existingRecord = existingRecords.first {
                existingRecord.phaseWeek = currentWeek
                existingRecord.phaseDay = currentDay
                existingRecord.phaseName = currentPhase
                existingRecord.lastCompletedItem = lastCompletedItem
                print("Updated \(currentPhase) with week \(currentWeek) and day \(currentDay) and lastCompletedItem \(lastCompletedItem)")

                currentPhase = existingRecord.phaseName
                currentWeek = existingRecord.phaseWeek
                currentDay = existingRecord.phaseDay
                lastCompletedItem = existingRecord.lastCompletedItem
            } else {
                let newRecord = PhaseRecord(phaseName: currentPhase, phaseWeek: currentWeek, phaseDay: currentDay, lastCompletedItem: lastCompletedItem, phaseWeekTotal: phaseManager.phaseRecord!.phaseWeekTotal)
                modelContext.insert(newRecord)
                print("Saved new \(currentPhase) with week \(currentWeek) and day \(currentDay) and lastCompletedItem \(lastCompletedItem)")
            }

            try modelContext.save()

        } catch {
            print("Failed to fetch or save phase:", error)
        }
    }
}
