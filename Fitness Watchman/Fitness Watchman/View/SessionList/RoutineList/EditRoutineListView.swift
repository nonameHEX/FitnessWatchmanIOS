//
//  EditRoutineListView.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 07.06.2024.
//

import SwiftUI

struct EditRoutineListView: View {
    @Binding var isViewPresented: Bool
    @StateObject var routineListViewModel: RoutineListViewModel
    
    @State var routineName: String = ""
    @State var dayOfWeek: Session.DayOfWeek = .none
    
    var body: some View {
        NavigationView {
            Form{
                Section("Název seznamu"){
                    TextField("Název seznamu", text: $routineName)
                        .ClearButton(text: $routineName)
                }
                
                Section("Ve který den"){
                    Picker("Vyberte den:", selection: $dayOfWeek) {
                        ForEach(Session.DayOfWeek.allCases){ option in
                            Text(option.name)
                        }
                    }
                    .pickerStyle(.inline)
                }
            }
            .onAppear(){
                routineName = routineListViewModel.session.name
                dayOfWeek = routineListViewModel.session.atDay
            }
            .navigationBarItems(
                leading: Button("Zavřít") {
                    isViewPresented.toggle()
                },
                trailing: Button("Save") {
                    routineListViewModel.updateSession(
                        name: routineName,
                        atDay: dayOfWeek
                    )
                    isViewPresented.toggle()
                }.disabled(routineName.isEmpty)
            )
        }
    }
}
/*
#Preview {
    EditRoutineListView()
}
*/
