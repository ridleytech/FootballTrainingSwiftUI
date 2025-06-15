//
//  KPIListView.swift
//  FootballTraining
//
//  Created by Randall Ridley on 6/5/25.
//

import Foundation
import SwiftData
import SwiftUI

struct KPIListView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var viewModel: PhaseViewModel
    @EnvironmentObject var navigationManager: NavigationManager

    @State private var kpis: [TrainingKPI] = []

    // FetchDescriptor to query TrainingKPI objects from SwiftData

    private func fetchKPIs() {
        // Define the FetchDescriptor for TrainingKPI
        let fetchDescriptor = FetchDescriptor<TrainingKPI>(
            sortBy: [SortDescriptor(\TrainingKPI.exerciseName)] // Corrected SortDescriptor usage
        )

        do {
            kpis = try modelContext.fetch(fetchDescriptor)

//            print("kpis: \(kpis.count)")
        } catch {
            print("Error fetching KPIs: \(error)")
        }
    }

    var body: some View {
        NavigationView {
            List(kpis, id: \.id) { kpi in
                VStack(alignment: .leading) {
                    Text(kpi.exerciseName)
                        .font(.headline)
                    if let targetGoal = kpi.targetGoal {
                        Text("Target Goal: \(targetGoal)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

//                    else {
//                        Text("No target goal for: \(kpi.exerciseName)")
//                    }

                    if let currentProgress = kpi.currentProgress {
                        Text("Current Progress: \(currentProgress)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .onTapGesture {
                    viewModel.selectedKPI = kpi
                    navigationManager.path.append(Route.kpiDetails)
                }
            }
            .navigationTitle("Training KPIs")
            .navigationBarItems(trailing: Button(action: {
                // Action to add new KPI
                // This could navigate to a new screen for adding a KPI, for example
            }) {
                Image(systemName: "plus")
            })
            .onAppear {
                fetchKPIs()
            }
        }
    }
}

struct KPIListView_Previews: PreviewProvider {
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

            return KPIListView()
                .environmentObject(phaseManager)
                .environmentObject(PhaseViewModel())
        }
        .modelContainer(container)
    }
}
