//
//  PocketMonApp.swift
//  PocketMon
//
//  Created by HoangDus on 31/08/2024.
//

import SwiftUI

@main
struct PocketMonApp: App {
	let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
