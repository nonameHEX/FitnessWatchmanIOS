//
//  RoutineListView.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 23.04.2024.
//

import SwiftUI
import Lottie

struct RoutineListView: View {
    @StateObject var routineListViewModel: RoutineListViewModel
    
    @State var isExerciseViewPresented = false
    @State var isNewExerciseViewPresented = false
    @State var isEditRoutineListViewPresented = false
    
    @State var isEditingExercise = false
    
    var body: some View {
        VStack {
            if routineListViewModel.exercises.isEmpty {
                LottieView(animation: .named("Dumbbell"))
                    .playing()
                    .looping()
                    .resizable()
                    .frame(width: 100, height: 100)
                
                Text("Nemáte žádné cvíky v seznamu, přidejte si je otevřením kontextového menu v pravo nahoře")
                    .multilineTextAlignment(.center)
                    .padding()
            }
            List(routineListViewModel.exercises) { exercise in
                HStack{
                    Toggle("", isOn: Binding<Bool>(
                        get: { exercise.exerciseState },
                        set: { val in
                            routineListViewModel.updateExerciseState(exercise: exercise, newState: val)
                        }))
                        .labelsHidden()
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(exercise.name)
                                .font(.headline)
                            
                            Text("\(exercise.numberOfSeries) x \(exercise.numberOfRepeats) \(String(format: "%.1f", routineListViewModel.convertWeight(exercise.dumbbellWeight))) \(routineListViewModel.weightUnit.name)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right").foregroundColor(.secondary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isEditingExercise.toggle()
                        isExerciseViewPresented.toggle()
                        routineListViewModel.selectedExercise = exercise
                    }
                }
                .swipeActions {
                    Button(role: .destructive) {
                        routineListViewModel.deleteExercise(exercise: exercise)
                    } label: {
                        Image(systemName: "trash")
                    }
                }
                
            }
            .listStyle(PlainListStyle())
            
            ProgressView(value: routineListViewModel.dailyProgress){
                Text("\(Int(routineListViewModel.dailyProgress.isFinite ? routineListViewModel.dailyProgress * 100 : 0)) % progress")
            }
            .padding(8)
            .animation(.smooth)
            
        }
        .navigationTitle(routineListViewModel.session.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Upravit list") {
                        isEditRoutineListViewPresented.toggle()
                    }
                    Button("Přidat cvik") {
                        isNewExerciseViewPresented.toggle()
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
        .sheet(isPresented: $isNewExerciseViewPresented) {
            ExerciseDetailView(isViewPresented: $isNewExerciseViewPresented,
                               isEditing: $isEditingExercise,
                               routineListViewModel: routineListViewModel)
                .presentationDetents([.large])
        }
        .sheet(isPresented: $isExerciseViewPresented) {
            ExerciseDetailView(isViewPresented: $isExerciseViewPresented, 
                               isEditing: $isEditingExercise,
                               routineListViewModel: routineListViewModel)
                .presentationDetents([.large])
        }
        .fullScreenCover(isPresented: $isEditRoutineListViewPresented) {
            EditRoutineListView(isViewPresented: $isEditRoutineListViewPresented, 
                                routineListViewModel: routineListViewModel)
                .presentationDetents([.large])
        }
    }
}
/*
#Preview {
    RoutineListView()
}
*/
