//
//  MaxModel.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class MaxIntensityRecord {
    var exerciseName: String
    var maxIntensity: Double
    var dateRecorded: Date

    init(exerciseName: String, maxIntensity: Double, dateRecorded: Date = Date()) {
        self.exerciseName = exerciseName
        self.maxIntensity = maxIntensity
        self.dateRecorded = dateRecorded
    }
}

@Model
class PhaseRecord {
    var phaseName: String
    var phaseWeek: Int
    var phaseDay: String
    var lastCompletedItem: Int

    init(phaseName: String, phaseWeek: Int, phaseDay: String, lastCompletedItem: Int) {
        self.phaseName = phaseName
        self.phaseWeek = phaseWeek
        self.phaseDay = phaseDay
        self.lastCompletedItem = lastCompletedItem
    }

    var description: String {
        return """
        PhaseRecord:
        - Name: \(phaseName)
        - Week: \(phaseWeek)
        - Day: \(phaseDay)
        - Last Completed Item: \(lastCompletedItem)
        """
    }
}

struct ModelContextPreview<Content: View>: View {
    let container: ModelContainer
    @State private var isReady = false
    @State private var modelContext: ModelContext? = nil
    let content: (ModelContext) -> Content

    var body: some View {
        ZStack {
            if let modelContext {
                content(modelContext)
            } else {
                Color.clear.onAppear {
                    modelContext = container.mainContext
                }
            }
        }
    }
}
