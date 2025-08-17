//
//  Test.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import Foundation


////
//    func saveMaxIntensityAllowDuplicates(exerciseName: String, intensity: Double, context: ModelContext) {
//        let record = MaxIntensityRecord(exerciseName: exerciseName, maxIntensity: intensity)
//        context.insert(record)
//
//        do {
//            try context.save()
//            print("Saved \(exerciseName) with intensity \(intensity)")
//
//        } catch {
//            print("Failed to save:", error)
//        }
//    }
//
//    func saveMaxIntensity1(exerciseName: String, intensity: Double, context: ModelContext) {
//        // 1. Try to find if a record already exists
//        let descriptor = FetchDescriptor<MaxIntensityRecord>(predicate: #Predicate { $0.exerciseName == exerciseName })
//
//        if let existingRecord = try? context.fetch(descriptor).first {
//            // 2. If found, update it
//            existingRecord.maxIntensity = intensity
//            print("Updated existing record for \(exerciseName) with new intensity \(intensity)")
//        } else {
//            // 3. If not found, insert a new one
//            let record = MaxIntensityRecord(exerciseName: exerciseName, maxIntensity: intensity)
//            context.insert(record)
//            print("Inserted new record for \(exerciseName) with intensity \(intensity)")
//        }
//
//        // 4. Save changes
//        do {
//            try context.save()
//        } catch {
//            print("Failed to save:", error)
//        }
//    }


//NavigationSplitView {
//    List {
//        ForEach(items) { item in
//            NavigationLink {
//                Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//            } label: {
//                Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//            }
//        }
//        .onDelete(perform: deleteItems)
//    }
//    .toolbar {
//        ToolbarItem(placement: .navigationBarTrailing) {
//            EditButton()
//        }
//        ToolbarItem {
//            Button(action: addItem) {
//                Label("Add Item", systemImage: "plus")
//            }
//        }
//    }
//} detail: {
//    Text("Select an item")
//}

//private func addItem() {
//    withAnimation {
//        let newItem = Item(timestamp: Date())
//        modelContext.insert(newItem)
//    }
//}
//
//private func deleteItems(offsets: IndexSet) {
//    withAnimation {
//        for index in offsets {
//            modelContext.delete(items[index])
//        }
//    }
//}
