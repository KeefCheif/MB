//
//  MobileBrowser_NeevaApp.swift
//  MobileBrowser-Neeva
//
//  Created by peter allgeier on 8/18/22.
//

import SwiftUI

@main
struct MobileBrowser_NeevaApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
