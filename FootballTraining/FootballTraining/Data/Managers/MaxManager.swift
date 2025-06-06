//
//  MaxManager.swift
//  FootballTraining
//
//  Created by Randall Ridley on 6/5/25.
//

import Foundation
import SwiftData

class MaxManager: ObservableObject {
    @Published var weightRecord: WeightRecord?

    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadWeightRecord()
    }

    func loadWeightRecord() {
        do {
            var descriptor = FetchDescriptor<WeightRecord>()
            descriptor.fetchLimit = 1

            let records = try modelContext.fetch(descriptor)

            if let existing = records.last {
                weightRecord = existing
//                print("Loaded existing PhaseRecord: \(existing.description)")
            } else {
                let new = WeightRecord(weight: 188.0, dateRecorded: Date())
                modelContext.insert(new)
                try modelContext.save()
                weightRecord = new
                print("Created new WeightRecord")
            }

        } catch {
            print("Failed to load or create PhaseRecord:", error)
        }
    }
}
