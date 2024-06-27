//
//  WeeklyresetManager.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 12.06.2024.
//

import Foundation
import CoreData

class WeeklyResetManager {
    private let nextResetKey = "NextResetDate"
    private let coreDataService: CoreDataService
    
    //private var testNextResetDate: Date = Date()
    //private var testCurrentDate: Date = Date()
    
    init(moc: NSManagedObjectContext) {
        self.coreDataService = CoreDataService(moc: moc)
        
        //testNextResetDate = Calendar.current.date(byAdding: .day, value: 4, to: testNextResetDate) ?? Date()
        //testCurrentDate = Calendar.current.date(byAdding: .day, value: 5, to: testCurrentDate) ?? Date()
    }
    
    func checkAndPerformWeeklyResetIfNeeded() {
        //print(testNextResetDate)
        //print(testCurrentDate)
        let allUserDefaults = UserDefaults.standard.dictionaryRepresentation()
        //print(allUserDefaults)
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: nextResetKey) == nil {
            userDefaults.set(getNextSunday(for: Date.now), forKey: nextResetKey)
        }
        
        if let nextResetDate = userDefaults.object(forKey: nextResetKey) as? Date {
            let currentDate = Date()
            
            if shouldReset(nextResetDate: nextResetDate, currentDate: currentDate) {
                coreDataService.resetExerciseState()
                print("Provedl se týdenní reset stavu cvičení.")
                
                let newNextResetDate = getNextSunday(for: currentDate)
                userDefaults.set(newNextResetDate, forKey: nextResetKey)
            }
        }
    }
    
    private func shouldReset(nextResetDate: Date, currentDate: Date) -> Bool {
        return currentDate > nextResetDate
    }
    
    private func getNextSunday(for date: Date) -> Date {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let daysToAdd = 8 - weekday
        return calendar.date(byAdding: .day, value: daysToAdd, to: date) ?? date
    }
}
