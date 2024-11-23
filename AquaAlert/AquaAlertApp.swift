//
//  AquaAlertApp.swift
//  AquaAlert
//
//  Created by Suphi Erkin Karaçay on 6.11.2024.
//

import SwiftUI

@main
struct AquaAlertApp: App {
    @StateObject private var waterIntake = WaterIntake(dailyGoal: 2000)
    @State private var isCalculatorCompleted = false

    var body: some Scene {
        WindowGroup {
            if isCalculatorCompleted {
                ContentView(
                    waterIntake: waterIntake,
                    onBackToCalculator: { isCalculatorCompleted = false }
                )
            } else {
                CalculatorView(waterIntake: waterIntake) {
                    isCalculatorCompleted = true
                }
            }
        }
    }
}
