//
//  JournalViewModel.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 09.05.2024.
//

import Foundation
import CoreData
import UIKit

class JournalViewModel: ObservableObject {
    private (set) var moc: NSManagedObjectContext
    private var coreDataService: CoreDataService
    
    @Published var journalRecords: [JournalRecord] = []
    @Published var selectedJournalRecord: JournalRecord?
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
        self.coreDataService = CoreDataService(moc: moc)
    }
    
    func addNewJournalRecord(atDate: Date, image: UIImage, infoText: String){
        let newRecord = JournalRecord(atDate: atDate,
                                      image: image,
                                      infoText: infoText)
        coreDataService.addEJournalRecord(record: newRecord)
        journalRecords.append(newRecord)
    }
    
    func deleteJournalRecord(record: JournalRecord) {
        coreDataService.deleteEJournalRecord(record: record)
        journalRecords.remove(at: journalRecords.firstIndex(where: { $0.id == record.id }) ?? -1)
    }
    
    func updateJournalRecord(infoText: String, image: UIImage){
        guard let selectedJournalRecord = self.selectedJournalRecord else {
            print("No exercise selected.")
            return
        }
        
        guard let recordToUpdate = coreDataService.fetchEJournalRecordByID(with: selectedJournalRecord.id) else {
            print("Exercise not found.")
            return
        }
        
        recordToUpdate.infoText = infoText
        recordToUpdate.imageData = image.jpegData(compressionQuality: 0.8)
        
        coreDataService.save()
        
        updateJournalRecordList(record: selectedJournalRecord)
    }
    
    private func updateJournalRecordList(record: JournalRecord){
        guard let eRecord = coreDataService.fetchEJournalRecordByID(with: record.id) else {
            return
        }
        guard let index = journalRecords.firstIndex(where: { $0.id == record.id }) else{
            return
        }
        let image: UIImage
        if let storedImageData = eRecord.imageData{
            image = UIImage(data: storedImageData) ?? UIImage()
        }else{
            image = UIImage(named: "empty") ?? UIImage()
        }
        
        journalRecords[index].infoText = eRecord.infoText ?? ""
        journalRecords[index].image = image
    }
    
    func FetchAllJournalRecords() {
        if (coreDataService.isJournalRecordsEmpty()){
            createSampleData()
        }
        let eJournalRecords = coreDataService.fetchAllEJournalRecords()
        
        journalRecords = eJournalRecords.map({ eRecord in
            let image: UIImage
            if let storedImageData = eRecord.imageData{
                image = UIImage(data: storedImageData) ?? UIImage()
            }else{
                image = UIImage(named: "empty") ?? UIImage()
            }
            return JournalRecord(
                id: eRecord.id ?? UUID(),
                atDate: eRecord.atDate ?? Date.now,
                image: image,
                infoText: eRecord.infoText ?? ""
            )
        })
    }
    
    private func createSampleData() {
        // Create samples
        let record1 = JournalRecord(atDate: Date.now, image: UIImage(), infoText: "Test deníku 1")
        let record2 = JournalRecord(atDate: Date.now, image: UIImage(), infoText: "Test deníku 2")
    
        coreDataService.addEJournalRecord(record: record1)
        coreDataService.addEJournalRecord(record: record2)
        
        journalRecords.append(record1)
        journalRecords.append(record2)
    }
    
    func getDateNowFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter.string(from: Date.now)
    }
    
    func printJDB(){
        let eRecord = coreDataService.fetchAllEJournalRecords()
        
        eRecord.forEach { eJournalRecord in
            print("\(String(describing: eJournalRecord.id))\n\(String(describing: eJournalRecord.atDate)) \(eJournalRecord.infoText ?? "")")
        }
    }
}
