//
//  SessionListViewModel.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 09.05.2024.
//

import Foundation
import CoreData

class SessionListViewModel: ObservableObject {
    private (set) var moc: NSManagedObjectContext
    private var coreDataService: CoreDataService
    
    @Published var sessions: [Session] = []
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
        self.coreDataService = CoreDataService(moc: moc)
    }
    
    func addNewSession(){
        let newSession = Session(name: "Nový list cviků")
        coreDataService.addESession(session: newSession)
        sessions.append(newSession)
    }
    
    func deleteSession(session: Session) {
        coreDataService.deleteESession(session: session)
        sessions.remove(at: sessions.firstIndex(where: { $0.id == session.id }) ?? -1)
    }
    
    func fetchAllSessions(){
        if(coreDataService.isSessionsEmpty()){
            createSampleData()
        }
        let eSessions = coreDataService.fetchAllESessions()
        
        self.sessions = eSessions.map { eSession in
            let exercises = (eSession.exercise)?.array as? [EExercise] ?? []
            return Session(
                id: eSession.id ?? UUID(),
                name: eSession.name ?? "",
                atDay: Session.DayOfWeek(rawValue: eSession.atDay) ?? .none,
                exerciseList: exercises.map { eExercise in
                    Exercise(
                        id: eExercise.id ?? UUID(),
                        name: eExercise.name ?? "",
                        numberOfSeries: Int(eExercise.numberOfSeries),
                        numberOfRepeats: Int(eExercise.numberOfRepeats),
                        dumbbellWeight: eExercise.dumbbellWeight,
                        infoForNextSession: eExercise.infoForNextSession ?? "",
                        exerciseState: eExercise.exerciseState
                    )
                }
            )
        }
    }
    
    private func createSampleData() {
        // Create samples
        let cvik1 = Exercise(name: "Dřep", numberOfSeries: 3, numberOfRepeats: 10, dumbbellWeight: 60.5, infoForNextSession: "", exerciseState: true)
        let cvik2 = Exercise(name: "Leg press", numberOfSeries: 3, numberOfRepeats: 10, dumbbellWeight: 90.5, infoForNextSession: "", exerciseState: false)
        let session1 = Session(name: "Nohy", atDay: .Monday, exerciseList: [cvik1, cvik2])
        
        let cvik3 = Exercise(name: "Tlaky", numberOfSeries: 3, numberOfRepeats: 10, dumbbellWeight: 20.5, infoForNextSession: "", exerciseState: false)
        let cvik4 = Exercise(name: "Bench", numberOfSeries: 3, numberOfRepeats: 10, dumbbellWeight: 70.0, infoForNextSession: "", exerciseState: true)
        let session2 = Session(name: "Prsa", atDay: .Friday, exerciseList: [cvik3, cvik4])
        
        coreDataService.addESession(session: session1)
        coreDataService.addESession(session: session2)
    }
    
    func printDB(){
        print("\(Date.now) přechod na sessionlistview")
        let eSessions = coreDataService.fetchAllESessions()
        let eExercises = coreDataService.fetchAllEExercies()
        
        eSessions.forEach { eSession in
            print("\(eSession.name ?? "") \(String(describing: eSession.exercise))")
        }
        
        eExercises.forEach { eExercise in
            print("\(eExercise.name ?? ""): \(eExercise.exerciseState)")
        }
    }
}
