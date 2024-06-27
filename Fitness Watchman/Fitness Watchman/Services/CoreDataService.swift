//
//  CoreDataService.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 06.06.2024.
//

import Foundation
import CoreData

class CoreDataService{
    private var moc: NSManagedObjectContext

    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    func fetchESessionByID(with id: UUID) -> ESession? {
        let fetchRequest: NSFetchRequest<ESession> = ESession.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            return try moc.fetch(fetchRequest).first
        } catch {
            print("Error fetching session: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchEExerciseByID(with id: UUID) -> EExercise? {
        let fetchRequest: NSFetchRequest<EExercise> = EExercise.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            return try moc.fetch(fetchRequest).first
        } catch {
            print("Error fetching exercise: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchEJournalRecordByID(with id: UUID) -> EJournalRecord? {
        let fetchRequest: NSFetchRequest<EJournalRecord> = EJournalRecord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            return try moc.fetch(fetchRequest).first
        } catch {
            print("Error fetching journal record: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchAllESessions() -> [ESession]{
        let request = NSFetchRequest<ESession>(entityName: "ESession")
        var eSessions: [ESession] = []
        
        do {
            eSessions =  try moc.fetch(request)
        } catch {
            print("Failed to fetch sessions: \(error.localizedDescription)")
        }
        return eSessions
    }
    
    func fetchAllEExercies() -> [EExercise]{
        let request = NSFetchRequest<EExercise>(entityName: "EExercise")
        var eExercises: [EExercise] = []
        
        do {
            eExercises = try moc.fetch(request)
        } catch {
            print("Failed to fetch exercises: \(error.localizedDescription)")
        }
        return eExercises
    }
    
    func fetchAllEJournalRecords() -> [EJournalRecord] {
        let request = NSFetchRequest<EJournalRecord>(entityName: "EJournalRecord")
        var eJournalRecords: [EJournalRecord] = []
        
        do {
            eJournalRecords = try moc.fetch(request)
        } catch {
            print("Failed to fetch journal records: \(error.localizedDescription)")
        }
        return eJournalRecords
    }
    
    func addESession(session: Session){
        let eSession = ESession(context: moc)
        eSession.id = session.id
        eSession.name = session.name
        eSession.atDay = session.atDay.rawValue
        
        let exercises = NSOrderedSet(array: session.exerciseList.map { exercise in
            let eExercise = EExercise(context: moc)
            eExercise.id = exercise.id
            eExercise.name = exercise.name
            eExercise.numberOfSeries = Int16(exercise.numberOfSeries)
            eExercise.numberOfRepeats = Int16(exercise.numberOfRepeats)
            eExercise.dumbbellWeight = exercise.dumbbellWeight
            eExercise.infoForNextSession = exercise.infoForNextSession
            eExercise.exerciseState = exercise.exerciseState
            eExercise.session = eSession
            return eExercise
        })
        eSession.exercise = exercises
        
        save()
    }
    
    func deleteESession(session: Session) {
        guard let sessionToDelete = fetchESessionByID(with: session.id) else {
            print("Session not found.")
            return
        }
        moc.delete(sessionToDelete)
        
        save()
    }
    
    func addEExercise(exercise: Exercise, sessionID: UUID) {
        let newEExercise = EExercise(context: moc)
        newEExercise.id = exercise.id
        newEExercise.name = exercise.name
        newEExercise.numberOfSeries = Int16(exercise.numberOfSeries)
        newEExercise.numberOfRepeats = Int16(exercise.numberOfRepeats)
        newEExercise.dumbbellWeight = exercise.dumbbellWeight
        newEExercise.infoForNextSession = exercise.infoForNextSession
        newEExercise.exerciseState = exercise.exerciseState
        
        if let eSession = fetchESessionByID(with: sessionID) {
            newEExercise.session = eSession
        } else {
            print("Session not found.")
        }
        
        save()
    }
    
    func deleteEExercise(exercise: Exercise) {
        guard let exerciseToDelete = fetchEExerciseByID(with: exercise.id) else {
            print("Exercise not found.")
            return
        }
        moc.delete(exerciseToDelete)
        save()
    }
    
    func addEJournalRecord(record: JournalRecord) {
        let newEJournalRecord = EJournalRecord(context: moc)
        newEJournalRecord.id = UUID()
        newEJournalRecord.atDate = record.atDate
        newEJournalRecord.infoText = record.infoText
        newEJournalRecord.imageData = record.image.jpegData(compressionQuality: 0.8)
        
        save()
    }
    
    func deleteEJournalRecord(record: JournalRecord) {
        guard let journalRecordToDelete = fetchEJournalRecordByID(with: record.id) else {
            print("Journal record not found.")
            return
        }
        moc.delete(journalRecordToDelete)
        save()
    }
    
    func save() {
        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                print("Cannot save MOC: \(error.localizedDescription)")
            }
        }
    }

    func isSessionsEmpty() -> Bool {
        let request = NSFetchRequest<ESession>(entityName: "ESession")
        do {
            let count = try moc.count(for: request)
            return count == 0
        } catch {
            print("Error counting entities: \(error.localizedDescription)")
            return true
        }
    }
    
    func isJournalRecordsEmpty() -> Bool {
        let request = NSFetchRequest<EJournalRecord>(entityName: "EJournalRecord")
        do {
            let count = try moc.count(for: request)
            return count == 0
        } catch {
            print("Error counting entities: \(error.localizedDescription)")
            return true
        }
    }
    
    func convertWeightToPreferredUnit(_ weight: Double) -> Double {
        let preferredUnitIsKg = UserDefaults.standard.integer(forKey: "Unit") == 1
        if preferredUnitIsKg {
            return weight
        } else {
            return weight * 2.20462
        }
    }
    
    func convertWeightToBaseUnit(_ weight: Double) -> Double {
        let preferredUnitIsKg = UserDefaults.standard.integer(forKey: "Unit") == 1
        if preferredUnitIsKg {
            return weight
        } else {
            return weight / 2.20462
        }
    }
    
    func resetExerciseState() {
        let exercises = fetchAllEExercies()
        
        for exercise in exercises {
            exercise.exerciseState = false
        }
        
        save()
    }
}
