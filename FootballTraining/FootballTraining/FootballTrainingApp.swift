//
//  FootballTrainingApp.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import SwiftData
import SwiftUI

struct ModelContextView<Content: View>: View {
    @Environment(\.modelContext) private var modelContext
    let content: (ModelContext) -> Content

    var body: some View {
        content(modelContext)
    }
}

@main
struct FootballTrainingApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            MaxIntensityRecord.self,
            PhaseRecord.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @StateObject private var navigationManager = NavigationManager()

    var body: some Scene {
        WindowGroup {
            ModelContextView { modelContext in
                let phaseManager = PhaseManager(modelContext: modelContext)

                return ContentView()
                    .environmentObject(navigationManager)
                    .environmentObject(phaseManager)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
