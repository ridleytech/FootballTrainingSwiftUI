//
//  PhaseManager.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/27/25.
//

import Foundation
import SwiftData
import SwiftUI

import Foundation
import SwiftData

class PhaseManager: ObservableObject {
    @Published var phaseRecord: PhaseRecord?

    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadOrCreatePhaseRecord()
    }

    func loadOrCreatePhaseRecord() {
        do {
            var descriptor = FetchDescriptor<PhaseRecord>()
            descriptor.fetchLimit = 1

            let records = try modelContext.fetch(descriptor)

            if let existing = records.first {
                phaseRecord = existing
                print("Loaded existing PhaseRecord: \(existing.description)")
            } else {
                let new = PhaseRecord(phaseName: "Postseason", phaseWeek: 1, phaseDay: "Monday", lastCompletedItem: 0, phaseWeekTotal: 5)
                modelContext.insert(new)
                try modelContext.save()
                phaseRecord = new
                print("Created new PhaseRecord")
            }

        } catch {
            print("Failed to load or create PhaseRecord:", error)
        }
    }

    func update(phaseName: String, phaseWeek: Int, phaseDay: String, lastCompletedItem: Int, phaseWeekTotal: Int) {
        guard let record = phaseRecord else { return }

        record.phaseName = phaseName
        record.phaseWeek = phaseWeek
        record.phaseDay = phaseDay
        record.lastCompletedItem = lastCompletedItem
        record.phaseWeekTotal = phaseWeekTotal

        do {
            try modelContext.save()
            print("Updated PhaseRecord: \(record.description)")
        } catch {
            print("Failed to update PhaseRecord:", error)
        }
    }
}
