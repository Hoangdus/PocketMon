//
//  Persistence.swift
//  PocketMon
//
//  Created by HoangDus on 13/06/2025.
//

import Foundation
import CoreData

struct PersistenceController {
	static let shared = PersistenceController()

    let container = NSPersistentContainer(name: "LocalPokemonData")
    
	init(inMemory: Bool = false) {
        
        let sqliteURL = URL.storeURL(for: "group.hoangdus.pocketmon", databaseName: "localPokemonData")
		if inMemory {
			container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }else{
            container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: sqliteURL)]
        }
        
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
//		container.viewContext.automaticallyMergesChangesFromParent = true
	}
}

public extension URL {

    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
