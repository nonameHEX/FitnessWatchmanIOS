//
//  Exercise.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 07.05.2024.
//

import Foundation

struct Exercise: Identifiable {
    var id = UUID()
    var name: String
    var numberOfSeries: Int
    var numberOfRepeats: Int
    var dumbbellWeight: Double
    var infoForNextSession: String
    var exerciseState: Bool
    
    enum DumbbellWeightUnit: Int16, CaseIterable, Identifiable {
        var id: Self { self }
        
        case Kg = 1
        case Lb = 2
        
        var name: String {
            switch self {
            case .Kg:
                return "Kg"
            case .Lb:
                return "Lb"
            }
        }
    }
}
