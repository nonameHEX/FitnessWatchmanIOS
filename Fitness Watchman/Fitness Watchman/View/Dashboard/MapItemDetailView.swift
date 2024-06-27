//
//  MapItemDetailView.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 09.06.2024.
//

import SwiftUI

struct MapItemDetailView: View {
    @Binding var isViewPresented: Bool
    @StateObject var dashboardViewModel: DashboardViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                Text(dashboardViewModel.selectedGym?.name ?? "")
                    .font(.title)
                
                Text("Vzdálenost od vás: \(Int(dashboardViewModel.selectedGym?.distance ?? 0)) m")
                    .font(.headline)
                
                Button(action: {
                    dashboardViewModel.navigate(to: dashboardViewModel.selectedGym?.coords ?? .init(latitude: 0, longitude: 0))
                }) {
                    Text("Navigovat do poslovny")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    if let url = dashboardViewModel.selectedGym?.gymUrl {
                        dashboardViewModel.openURL(url)
                    }
                }) {
                    Text("Otevřít web posilovny")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Text("Číslo na recepci: \(dashboardViewModel.selectedGym?.phoneNumber ?? "Číslo nenalezeno")")
                    .foregroundColor(.secondary)
                    .onTapGesture {
                        
                    }
            }
            .navigationBarItems(
                leading: Button("Zavřít") {
                    isViewPresented.toggle()
                })
            .padding()
        }
    }
}

/*
#Preview {
    MapItemDetailView()
}
*/
