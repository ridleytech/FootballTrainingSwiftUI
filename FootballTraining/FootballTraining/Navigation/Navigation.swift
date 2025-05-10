//
//  Navigation.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/27/25.
//

import Foundation
import SwiftUI

enum Route: Hashable {
    case dayWorkout
    case exerciseDetail
    case currentSet
}

enum Route2: Hashable {
    case dayWorkout(currentPhase: String, currentDay: String, currentWeek: Int, lastCompletedItem: Int)
    case exerciseDetail(selectedExercise: DayExercises, lastCompletedItem: Int, selectedExerciseIndex: Int, maxDataChanged: Bool)
    case currentSet(dayExercises: DayExercises, lastCompletedItem: Int)
}

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
}
