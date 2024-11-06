//
//  AquaAlertApp.swift
//  AquaAlert
//
//  Created by Suphi Erkin Karaçay on 6.11.2024.
//

import SwiftUI

@main
struct AquaAlertApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
