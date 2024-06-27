//
//  Gym.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 07.05.2024.
//

import Foundation
import MapKit

struct Gym: Identifiable {
    var id = UUID()
    var name: String
    var address: String
    var coords: CLLocationCoordinate2D
    var gymUrl: URL?
    var phoneNumber: String
    var distance: Double
}
