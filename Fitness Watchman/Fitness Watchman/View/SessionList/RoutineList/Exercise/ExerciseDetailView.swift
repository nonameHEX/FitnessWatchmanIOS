//
//  ExerciseDetailView.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 07.05.2024.
//

import SwiftUI

struct ExerciseDetailView: View {
    @Binding var isViewPresented: Bool
    @Binding var isEditing: Bool
    @StateObject var routineListViewModel: RoutineListViewModel
    
    @State var exerciseName: String = ""
    @State var numberOfSeries: String = ""
    @State var numberOfRepeats: String = ""
    @State var dumbbellWeight: String = ""
    @State var description: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Název cviku") {
                    TextField("Název cviku", text: $exerciseName)
                        .ClearButton(text: $exerciseName)
                }
                Section("Počet sérií") {
                    TextField("Počet sérií", text: $numberOfSeries)
                        .ClearButton(text: $numberOfSeries)
                }
                Section("Počet opakování") {
                    TextField("Počet opakování", text: $numberOfRepeats)
                        .ClearButton(text: $numberOfRepeats)
                }
                Section("Váha v (\(routineListViewModel.weightUnit.name))") {
                    TextField("Váha", text: $dumbbellWeight)
                        .ClearButton(text: $dumbbellWeight)
                }
                Section("Bonusové informace ke cviku") {
                    TextField("Bonusové informace ke cviku", text: $description, axis: .vertical)
                        .lineLimit(10...10)
                        .MultilineClearButton(text: $description)
                }
            }
            .onAppear {
                if(isEditing){
                    exerciseName = routineListViewModel.selectedExercise!.name
                    numberOfSeries = routineListViewModel.selectedExercise!.numberOfSeries == 0 ? "" : String(routineListViewModel.selectedExercise!.numberOfSeries)
                    numberOfRepeats = routineListViewModel.selectedExercise!.numberOfRepeats == 0 ? "" : String(routineListViewModel.selectedExercise!.numberOfRepeats)
                    dumbbellWeight = routineListViewModel.selectedExercise!.dumbbellWeight == 0 ? "" : String(format: "%.1f", routineListViewModel.convertWeight(routineListViewModel.selectedExercise!.dumbbellWeight))
                    description = routineListViewModel.selectedExercise!.infoForNextSession
                }
                
            }
            .navigationBarItems(
                leading: Button("Zavřít") {
                    if(isEditing){
                        isEditing.toggle()
                    }
                    isViewPresented.toggle()
                },
                trailing: Button("Save") {
                    let series = Int(numberOfSeries) ?? 0
                    let repeats = Int(numberOfRepeats) ?? 0
                    let weight = Double(dumbbellWeight) ?? 0.0
                    
                    if(isEditing){
                    routineListViewModel.updateExercise(
                        name: exerciseName,
                        numberOfSeries: series,
                        numberOfRepeats: repeats,
                        dumbbellWeight: weight,
                        description: description
                    )
                        isEditing.toggle()
                    }else{
                        routineListViewModel.addNewExercise(
                            name: exerciseName,
                            numberOfSeries: series,
                            numberOfRepeats: repeats,
                            dumbbellWeight: weight,
                            description: description
                        )
                    }
                    isViewPresented.toggle()
                }.disabled(exerciseName.isEmpty)
            )
        }
    }
}
/*
#Preview {
    ExerciseDetailView()
}
*/
