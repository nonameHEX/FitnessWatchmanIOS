//
//  Session.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 07.05.2024.
//

import Foundation

struct Session: Identifiable {
    var id = UUID()
    var name: String
    var atDay: DayOfWeek
    var exerciseList: [Exercise]
    
    init(id: UUID = UUID(), name: String = "", atDay: DayOfWeek = .none, exerciseList: [Exercise] = []) {
        self.id = id
        self.name = name
        self.atDay = atDay
        self.exerciseList = exerciseList
    }
    
    enum DayOfWeek: Int16, CaseIterable, Identifiable {
        var id: Self { self }
        
        case none = 0
        case Monday = 1
        case Tuesday = 2
        case Wednesday = 3
        case Thursday = 4
        case Friday = 5
        case Saturday = 6
        case Sunday = 7
        
        var name: String {
            switch self {
            case.none:
                return "Den není zvolen"
            case .Monday:
                return "Pondělí"
            case .Tuesday:
                return "Úterý"
            case .Wednesday:
                return "Středa"
            case .Thursday:
                return "Čtvrtek"
            case .Friday:
                return "Pátek"
            case .Saturday:
                return "Sobota"
            case .Sunday:
                return "Neděle"
            }
        }
    }
}
