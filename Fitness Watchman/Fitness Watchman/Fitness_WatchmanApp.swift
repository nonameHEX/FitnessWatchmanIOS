//
//  Fitness_WatchmanApp.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 23.04.2024.
//

import SwiftUI

@main
struct Fitness_WatchmanApp: App {
    @StateObject private var dataController = CoreDataController()
    var body: some Scene {
        
        WindowGroup {
            ContentView(dashboardViewModel: DashboardViewModel(moc: dataController.container.viewContext),
                        sessionListViewModel: SessionListViewModel(moc: dataController.container.viewContext),
                        journalViewModel: JournalViewModel(moc: dataController.container.viewContext))
            .onAppear {
                let resetManager = WeeklyResetManager(moc: dataController.container.viewContext)
                resetManager.checkAndPerformWeeklyResetIfNeeded()
            }
        }
    }
}
