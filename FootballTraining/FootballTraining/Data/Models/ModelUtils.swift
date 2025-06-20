//
//  ModelUtls.swift
//  FootballTraining
//
//  Created by Randall Ridley on 5/1/25.
//

import Foundation
import SwiftData

class ModelUtils {
    static let phaseOptions = ["Postseason", "Winter", "Spring", "Summer", "Preseason", "In-Season"]

    static func getNextPhase(currentPhase: String) -> String? {
        guard let currentIndex = phaseOptions.firstIndex(of: currentPhase) else {
            return nil // currentPhase not found in options
        }

        let nextIndex = (currentIndex + 1) % phaseOptions.count
        return phaseOptions[nextIndex]
    }

    static func getNextDay(currentDay: String) -> String? {
        let days = ["Monday", "Tuesday", "Thursday", "Friday"]

        guard let currentIndex = days.firstIndex(of: currentDay) else {
            return nil // Invalid day
        }

        let nextIndex = (currentIndex + 1) % days.count
        return days[nextIndex]
    }

    static func updatePhase(dayExerciseCount: Int,
                            currentPhase: inout String,
                            currentDay: inout String,
                            currentWeek: inout Int,
                            completedDayExercises: inout [DayExercise],
                            completedDayConditioningExercises: inout [DayExercise],
                            completedDayAccelerationExercises: inout [DayExercise],
                            skippedExercises: inout SkippedExercises,
                            phaseManager: PhaseManager,
                            modelContext: ModelContext,
                            dayCompleted: Bool)
    {
        print("updatePhase ModelUtils")

        //            when day workout is finished,
        //            check if last exercise in day, if so, advance to next day, week, or phase

        do {
            let completedExerciseCount = completedDayExercises.count + completedDayConditioningExercises.count + completedDayAccelerationExercises.count

            if (completedExerciseCount == dayExerciseCount) || dayCompleted == true {
                if currentDay == "Friday" {
                    if currentWeek == phaseManager.phaseRecord!.phaseWeekTotal {
                        print("go to next phase")

                        if let nextPhase = getNextPhase(currentPhase: currentPhase) {
                            currentPhase = nextPhase
                            currentWeek = 1
                            currentDay = "Monday"
                            completedDayExercises = []
                            completedDayConditioningExercises = []
                            completedDayAccelerationExercises = []
                            print("Next phase: \(currentPhase)")
                        }

                    } else {
                        currentWeek += 1
                        print("new currentWeek: \(currentWeek)")

                        currentDay = "Monday"
                        completedDayExercises = []
                        completedDayConditioningExercises = []
                        completedDayAccelerationExercises = []
                        print("go to next week")
                    }
                } else if let nextDay = getNextDay(currentDay: currentDay) {
                    currentDay = nextDay
                    completedDayExercises = []
                    completedDayConditioningExercises = []
                    completedDayAccelerationExercises = []
                    print("Next day: \(currentDay)")
                }
            }

            print("currentWeek: \(currentWeek)")

            phaseManager.update(
                phaseName: currentPhase,
                phaseWeek: currentWeek,
                phaseDay: currentDay,
                phaseWeekTotal:
                phaseManager.phaseRecord!.phaseWeekTotal,
                completedDayExercises: completedDayExercises,
                completedDayConditioningExercises: completedDayConditioningExercises,
                completedDayAccelerationExercises: completedDayAccelerationExercises,
                skippedExercises: skippedExercises
            )

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
                existingRecord.completedDayExercises = completedDayExercises
                existingRecord.completedDayConditioningExercises = completedDayConditioningExercises
                existingRecord.completedDayAccelerationExercises = completedDayAccelerationExercises

                print("Updated \(currentPhase) with week \(currentWeek) and day \(currentDay) and completedDayExercises \(completedDayExercises) and completedDayConditioningExercises \(completedDayConditioningExercises) and completedDayAccelerationExercises \(completedDayAccelerationExercises)")

                currentPhase = existingRecord.phaseName
                currentWeek = existingRecord.phaseWeek
                currentDay = existingRecord.phaseDay
                completedDayExercises = existingRecord.completedDayExercises
                completedDayConditioningExercises = existingRecord.completedDayConditioningExercises
                completedDayAccelerationExercises = existingRecord.completedDayAccelerationExercises
            } else {
                let newRecord = PhaseRecord(
                    phaseName: currentPhase,
                    phaseWeek: currentWeek,
                    phaseDay: currentDay,
                    phaseWeekTotal:
                    phaseManager.phaseRecord!.phaseWeekTotal,
                    completedDayExercises: completedDayExercises,
                    completedDayConditioningExercises: completedDayConditioningExercises,
                    completedDayAccelerationExercises: completedDayAccelerationExercises,
                    skippedExercises: skippedExercises
                )
                modelContext.insert(newRecord)
                print("Saved new \(currentPhase) with week \(currentWeek) and day \(currentDay) and completedDayExercises \(completedDayExercises) and completedDayConditioningExercises \(completedDayConditioningExercises) and completedDayAccelerationExercises \(completedDayAccelerationExercises)")
            }

            try modelContext.save()

        } catch {
            print("Failed to fetch or save phase:", error)
        }
    }
}
