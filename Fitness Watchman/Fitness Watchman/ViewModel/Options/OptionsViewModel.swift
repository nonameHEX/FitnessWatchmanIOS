//
//  OptionsViewModel.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 09.05.2024.
//

import Foundation

class OptionsViewModel: ObservableObject {
    private let usernameKey = "Username"
    private let unitKey = "Unit"
    
    @Published var username: String = UserDefaults.standard.string(forKey: "Username") ?? ""
    @Published var selectedUnit: Exercise.DumbbellWeightUnit = UserDefaults.standard.integer(forKey: "Unit") == 1 ? .Kg : .Lb
    
    func saveUsername() {
        UserDefaults.standard.set(username, forKey: usernameKey)
    }
        
    func saveSelectedUnit() {
        UserDefaults.standard.set(selectedUnit.rawValue, forKey: unitKey)
    }
}
