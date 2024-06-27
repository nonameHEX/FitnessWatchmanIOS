//
//  ContentView.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 23.04.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var dashboardViewModel: DashboardViewModel
    @StateObject var sessionListViewModel: SessionListViewModel
    @StateObject var journalViewModel: JournalViewModel
    
    @State private var showWelcomeMessage = false
    @State private var userName: String = ""
    
    private let usernameKey = "Username"
    
    var body: some View {
        ZStack {
            TabView {
                DashboardView(dashboardViewModel: dashboardViewModel)
                    .tabItem {
                        Label("Nástěnka", systemImage: "list.bullet.clipboard")
                    }
                SessionListView(sessionListViewModel: sessionListViewModel)
                    .tabItem {
                        Label("Seznam", systemImage: "list.dash")
                    }
                JournalView(journalViewModel: journalViewModel)
                    .tabItem {
                        Label("Deník", systemImage: "book")
                    }
            }
            
            if showWelcomeMessage {
                VStack {
                    Text("Vítejte \(userName)!")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.easeInOut(duration: 1.0), value: showWelcomeMessage)
            }
        }
        .onAppear {
            if let storedName = UserDefaults.standard.string(forKey: usernameKey), !storedName.isEmpty {
                userName = storedName
                showWelcomeMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showWelcomeMessage = false
                    }
                }
            }
        }
    }
}
/*
#Preview {
    ContentView()
}
*/
