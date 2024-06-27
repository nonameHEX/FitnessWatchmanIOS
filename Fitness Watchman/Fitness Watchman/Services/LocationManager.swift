//
//  LocationManager.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 09.05.2024.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
        
    @Published var position: MapCameraPosition = .camera(
        .init(centerCoordinate: .init(latitude: 49.20745296560573, longitude: 16.614868420174716), distance: 3000)
    )
    
    @Published var positionCoords: CLLocationCoordinate2D? = nil
    @Published var nearbyGyms: [Gym] = []
    
    override init(){
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let actLocation = locations.first{
            let coords = actLocation.coordinate
            position = .camera(
                .init(centerCoordinate: .init(latitude: coords.latitude, longitude: coords.longitude), distance: 3000)
            )
            positionCoords = .init(latitude: coords.latitude, longitude: coords.longitude)
            
            searchNearbyGyms(at: actLocation)
        }
    }
    
    func getCurrentDistance(to: CLLocationCoordinate2D) -> Double? {
        if let fromCoords = positionCoords{
            let fromLocation: CLLocation = .init(latitude: fromCoords.latitude,
                                                 longitude: fromCoords.longitude)
            let toLocation: CLLocation = .init(latitude: to.latitude, longitude: to.longitude)
            return fromLocation.distance(from: toLocation)
        }
        return nil
    }
    
    private func searchNearbyGyms(at location: CLLocation) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "fitness gym"
        request.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error searching for gyms: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                self.nearbyGyms = response.mapItems.map { mapItem in
                    Gym(
                        name: mapItem.name ?? "Unknown",
                        address: mapItem.placemark.title ?? "Unknown address",
                        coords: mapItem.placemark.coordinate,
                        gymUrl: mapItem.url,
                        phoneNumber: mapItem.phoneNumber ?? "Unknown phone number",
                        distance: self.getCurrentDistance(to: mapItem.placemark.coordinate) ?? 0
                    )
                }
            }
        }
    }
}
