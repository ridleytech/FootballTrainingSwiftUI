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

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
}
