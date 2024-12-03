//
//  CoreDataController.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 09.05.2024.
//

import Foundation
import CoreData

class CoreDataController: ObservableObject {
    let container = NSPersistentContainer(name: "Fitness Watchman")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Datafailed to create container: \(error.localizedDescription)")
            }
        }
    }
}
