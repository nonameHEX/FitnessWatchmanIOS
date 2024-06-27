//
//  DashboardViewModel.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 09.05.2024.
//

import Foundation
import CoreData
import CoreLocation
import UIKit

class DashboardViewModel: ObservableObject {
    private (set) var coreDataService: CoreDataService
    
    @Published var selectedGym: Gym?
    @Published var fullExerciseLoad: Double = 0
    @Published var currentExerciseLoad: Double = 0
    @Published var weeklyProgress: Float = 0
    @Published var weightUnit: Exercise.DumbbellWeightUnit = .Kg
    
    init(moc: NSManagedObjectContext) {
        self.coreDataService = CoreDataService(moc: moc)
    }
    
    func fetchData(){
        fetchDumbbellLoad()
        changeUnit()
    }
    
    func changeUnit(){
        weightUnit = UserDefaults.standard.integer(forKey: "Unit") == 1 ? .Kg : .Lb
    }
    
    func navigate(to: CLLocationCoordinate2D) {
        let url = URL(string: "maps://?saddr=&daddr=\(to.latitude),\(to.longitude)")
        if UIApplication.shared.canOpenURL(url!){
            UIApplication.shared.open(url!)
        }
    }
    
    func openURL(_ url: URL) {
            UIApplication.shared.open(url)
        }
    
    private func fetchDumbbellLoad(){
        fullExerciseLoad = 0
        currentExerciseLoad = 0
        let eExercises = coreDataService.fetchAllEExercies()
        
        eExercises.forEach { exercise in
            if(exercise.exerciseState){
                fullExerciseLoad += exercise.dumbbellWeight
                currentExerciseLoad += exercise.dumbbellWeight
            }else{
                fullExerciseLoad += exercise.dumbbellWeight
            }
        }
        fullExerciseLoad = coreDataService.convertWeightToPreferredUnit(fullExerciseLoad)
        currentExerciseLoad = coreDataService.convertWeightToPreferredUnit(currentExerciseLoad)
        
        calculateWeeklyProgress(exercises: eExercises)
    }
    
    private func calculateWeeklyProgress(exercises: [EExercise]){
        if(exercises.isEmpty){
            weeklyProgress = 0
            return
        }
        var progressSum: Float = 0
        exercises.forEach{exercise in
            progressSum += exercise.exerciseState == true ? 1 : 0
        }
        weeklyProgress = progressSum / Float(exercises.count)
    }
    
    func prepareExerciseChartData() -> [ChartData] {
        let sessions = coreDataService.fetchAllESessions()
        let exerciseCounts = processSessionData(sessions)
        
        var chartData: [ChartData] = []
        for exerciseCount in exerciseCounts {
            let dayName = exerciseCount.dayOfWeek.name
            let data = ChartData(day: dayName, exerciseCount: Double(exerciseCount.count))
            chartData.append(data)
        }
        
        return chartData
    }

    private func processSessionData(_ sessions: [ESession]) -> [ExerciseChart] {
        var exerciseCounts: [ExerciseChart] = []
        
        let daysOfWeek: [Session.DayOfWeek] = [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday, .Sunday]
        for dayOfWeek in daysOfWeek {
            exerciseCounts.append(ExerciseChart(dayOfWeek: dayOfWeek, count: 0))
        }
        
        for session in sessions {
            guard let dayOfWeek = Session.DayOfWeek(rawValue: session.atDay), dayOfWeek != .none else {
                continue
            }
            
            guard let exercises = session.exercise?.array as? [EExercise] else {
                continue
            }
            
            if let index = exerciseCounts.firstIndex(where: { $0.dayOfWeek == dayOfWeek }) {
                exerciseCounts[index].count += exercises.count
            }
        }
        
        return exerciseCounts
    }
}
