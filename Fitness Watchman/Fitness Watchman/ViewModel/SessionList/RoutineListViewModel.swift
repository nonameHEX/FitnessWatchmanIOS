//
//  RoutineListViewModel.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 09.05.2024.
//

import Foundation
import CoreData

class RoutineListViewModel: ObservableObject {
    private (set) var moc: NSManagedObjectContext
    private var coreDataService: CoreDataService
    
    @Published var exercises: [Exercise] = []
    @Published var selectedExercise: Exercise?
    @Published var dailyProgress: Float = 0
    @Published var session: Session
    
    @Published var weightUnit: Exercise.DumbbellWeightUnit = UserDefaults.standard.integer(forKey: "Unit") == 1 ? .Kg : .Lb
    
    init(moc: NSManagedObjectContext, session: Session) {
        self.moc = moc
        self.coreDataService = CoreDataService(moc: moc)
        self.session = session
        self.exercises = session.exerciseList
        calculateProgress()
    }
    
    func updateSession(name: String, atDay: Session.DayOfWeek){
        if let eSession = coreDataService.fetchESessionByID(with: session.id) {
            eSession.name = name
            eSession.atDay = atDay.rawValue
            coreDataService.save()
        } else {
            print("Session not found.")
        }
        session.name = name
        session.atDay = atDay
    }
    
    private func calculateProgress(){
        if(exercises.isEmpty){
            dailyProgress = 0
            return
        }
        var progressSum: Float = 0
        exercises.forEach{exercise in
            progressSum += exercise.exerciseState == true ? 1 : 0
        }
        dailyProgress = progressSum / Float(exercises.count)
    }
    
    func updateExerciseState(exercise: Exercise, newState: Bool){
        guard let index = exercises.firstIndex(where: { $0.id == exercise.id }) else{
            return
        }
        exercises[index].exerciseState = newState
        
        guard let exerciseToUpdate = coreDataService.fetchEExerciseByID(with: exercise.id) else {
            print("Exercise not found.")
            return
        }
        exerciseToUpdate.exerciseState = newState
        
        coreDataService.save()
        calculateProgress()
    }
    
    func updateExercise(name: String, numberOfSeries: Int, numberOfRepeats: Int, dumbbellWeight: Double, description: String){
        guard let selectedExercise = self.selectedExercise else {
            print("No exercise selected.")
            return
        }
        guard let exerciseToUpdate = coreDataService.fetchEExerciseByID(with: selectedExercise.id) else {
            print("Exercise not found.")
            return
        }
        
        exerciseToUpdate.name = name
        exerciseToUpdate.numberOfSeries = Int16(numberOfSeries)
        exerciseToUpdate.numberOfRepeats = Int16(numberOfRepeats)
        exerciseToUpdate.dumbbellWeight = coreDataService.convertWeightToBaseUnit(dumbbellWeight)
        exerciseToUpdate.infoForNextSession = description
            
        coreDataService.save()
        
        updateExerciseList(exercise: selectedExercise)
    }
    
    private func updateExerciseList(exercise: Exercise){
        guard let eExercise = coreDataService.fetchEExerciseByID(with: exercise.id) else {
            return
        }
        guard let index = exercises.firstIndex(where: { $0.id == exercise.id }) else{
            return
        }
        
        exercises[index].name = eExercise.name ?? ""
        exercises[index].numberOfSeries = Int(eExercise.numberOfSeries)
        exercises[index].numberOfRepeats = Int(eExercise.numberOfRepeats)
        exercises[index].dumbbellWeight = coreDataService.convertWeightToPreferredUnit(eExercise.dumbbellWeight)
        exercises[index].infoForNextSession = eExercise.infoForNextSession ?? ""
    }
    
    func deleteExercise(exercise: Exercise){
        print("Before del: \(exercises.count)")
        coreDataService.deleteEExercise(exercise: exercise)
        exercises.remove(at: exercises.firstIndex(where: { $0.id == exercise.id}) ?? -1)
        print("After del: \(exercises.count)")
        calculateProgress()
    }
    
    func addNewExercise(name: String, numberOfSeries: Int, numberOfRepeats: Int, dumbbellWeight: Double, description: String){
        let newExercise = Exercise(name: name,
                                   numberOfSeries: numberOfSeries,
                                   numberOfRepeats: numberOfRepeats,
                                   dumbbellWeight: coreDataService.convertWeightToBaseUnit(dumbbellWeight),
                                   infoForNextSession: description,
                                   exerciseState: false)
        
        coreDataService.addEExercise(exercise: newExercise, sessionID: session.id)

        exercises.append(newExercise)
    }
    
    func convertWeight(_ weight: Double) -> Double{
        return coreDataService.convertWeightToPreferredUnit(weight)
    }
}
