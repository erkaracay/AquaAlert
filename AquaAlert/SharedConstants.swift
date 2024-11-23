//
//  SharedConstants.swift
//  AquaAlert
//
//  Created by Suphi Erkin Karaçay on 11.11.2024.
//

import SwiftUI

class WaterIntake: ObservableObject {
    @Published var dailyGoal: Double

    init(dailyGoal: Double) {
        self.dailyGoal = dailyGoal
    }
}

enum AppState {
    case calculator
    case content
}
