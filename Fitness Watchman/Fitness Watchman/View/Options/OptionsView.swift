//
//  OptionsView.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 23.04.2024.
//

import SwiftUI


struct OptionsView: View {
    @StateObject var optionsViewModel: OptionsViewModel
    
    var onOptionsDismiss: (() -> Void)?
    
    var body: some View {
        VStack {
            Form{
                Section("Uživatelské jméno"){
                    TextField("Jméno", text: $optionsViewModel.username)
                        .ClearButton(text: $optionsViewModel.username)
                        .onChange(of: optionsViewModel.username, perform: { _ in
                            optionsViewModel.saveUsername()
                        })
                }
                Section("Jednotka vah"){
                    Picker("Metrika", selection: $optionsViewModel.selectedUnit) {
                        ForEach(Exercise.DumbbellWeightUnit.allCases) { unit in
                            Text(unit.name)
                        }
                    }
                    .onChange(of: optionsViewModel.selectedUnit, perform: { _ in
                        optionsViewModel.saveSelectedUnit()
                    })
                }
            }
        }
        .navigationTitle("⚙️ Nastavení")
        .onDisappear {
            onOptionsDismiss?()
        }
    }
}
/*
#Preview {
    OptionsView()
}
*/
