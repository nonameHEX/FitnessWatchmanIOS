//
//  JournalRecord.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 07.05.2024.
//

import Foundation
import UIKit

struct JournalRecord: Identifiable {
    var id = UUID()
    var atDate: Date
    var image: UIImage
    var infoText: String
    
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter.string(from: atDate)
    }
}
