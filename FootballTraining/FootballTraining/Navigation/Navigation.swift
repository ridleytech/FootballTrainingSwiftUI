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
    case dayWorkout
    case exerciseDetail(selectedExercise: DayExercise, selectedExerciseIndex: Int)
    case currentSet(currentExercise: DayExercise)
}

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
}
