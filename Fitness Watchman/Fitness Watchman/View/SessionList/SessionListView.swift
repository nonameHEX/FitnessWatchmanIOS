//
//  SessionListView.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 07.05.2024.
//

import SwiftUI

struct SessionListView: View {
    @StateObject var sessionListViewModel: SessionListViewModel
    
    var body: some View {
        NavigationView {
            List(sessionListViewModel.sessions) { session in
                NavigationLink(destination: RoutineListView(
                    routineListViewModel: RoutineListViewModel(
                        moc: sessionListViewModel.moc, session: session))) {
                    VStack(alignment: .leading) {
                            Text(session.name)
                                .font(.headline)
                            
                            if !session.atDay.name.isEmpty {
                                Text(session.atDay.name)
                                    .font(session.atDay.name.isEmpty ? .body : .callout)
                                    .foregroundColor(.secondary)
                            }
                        }
                }
                .swipeActions {
                    Button(role: .destructive) {
                        sessionListViewModel.deleteSession(session: session)
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
            .navigationTitle("💪 Seznam")
            .toolbar{
                ToolbarItem(placement: .bottomBar){
                    Button("Přidat seznam cviků"){
                        sessionListViewModel.addNewSession()
                    }
                }
            }
            .onAppear(){
                sessionListViewModel.fetchAllSessions()
            }
        }
    }
}
/*
#Preview {
    SessionListView()
}
*/
