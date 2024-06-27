//
//  BarModel.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 12.06.2024.
//

import Foundation

struct ChartData: Identifiable {
    let id = UUID()
    let day: String
    let exerciseCount: Double
}

struct ExerciseChart {
    var dayOfWeek: Session.DayOfWeek
    var count: Int
}
