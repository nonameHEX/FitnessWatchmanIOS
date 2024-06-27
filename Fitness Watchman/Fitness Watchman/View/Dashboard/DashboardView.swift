//
//  DashboardView.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 07.05.2024.
//

import SwiftUI
import MapKit
import Charts
import Lottie

struct DashboardView: View {
    @StateObject private var locationManager = LocationManager()
    
    @StateObject var dashboardViewModel: DashboardViewModel
    
    @State var isGymDetailPresented = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Celkem nazvedáno \(dashboardViewModel.weightUnit.name) tento týden"){
                    ProgressView(value: dashboardViewModel.weeklyProgress) {
                        HStack {
                            Spacer()
                            Text("\(String(format: "%.1f", dashboardViewModel.currentExerciseLoad)) / \(String(format: "%.1f", dashboardViewModel.fullExerciseLoad))")
                                .frame(maxWidth: .infinity, alignment: .center)
                            Spacer()
                        }
                        .padding(8)
                    }
                }
                
                Section("Počet cviku na každý den"){
                    let exerciseChartData = dashboardViewModel.prepareExerciseChartData()
                    
                    Chart(exerciseChartData) { item in
                        BarMark(
                            x: .value("Den", item.day),
                            y: .value("Počet cviků", item.exerciseCount)
                        )
                    }
                    .frame(height: 200)
                }
                
                Section("Posilovny v okolí"){
                    Map(position: $locationManager.position, interactionModes: [.pan, .zoom]){
                        ForEach(locationManager.nearbyGyms) { gym in
                            Annotation("", coordinate: gym.coords) {
                                VStack {
                                    ZStack {
                                        LottieView(animation: .named("MapPin"))
                                            .playing()
                                            .looping()
                                            .resizable()
                                            .frame(width: 50, height: 40)
                                    }
                                    Text(gym.name)
                                        .font(.caption)
                                }
                                .onTapGesture {
                                    dashboardViewModel.selectedGym = gym
                                    isGymDetailPresented.toggle()
                                }
                            }
                        }
                    }.mapControls {
                        MapScaleView()
                        MapUserLocationButton()
                        MapPitchToggle()
                    }.ignoresSafeArea(edges: .bottom)
                }.scaledToFill()
            }
            .navigationTitle("📊 Nástěnka")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: OptionsView(optionsViewModel: OptionsViewModel(), onOptionsDismiss: {
                        dashboardViewModel.fetchData()
                    })) {
                        Text("⚙️")
                    }
                }
            }
        }
        .sheet(isPresented: $isGymDetailPresented) {
            MapItemDetailView(isViewPresented: $isGymDetailPresented, dashboardViewModel: dashboardViewModel)
                .presentationDetents([.height(250)])
        }
        .onAppear(){
            dashboardViewModel.fetchData()
        }
    }
}

/*
#Preview {
    DashboardView()
}
 */
