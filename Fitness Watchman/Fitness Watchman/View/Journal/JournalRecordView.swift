//
//  NewJournalRecordView.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 08.06.2024.
//

import SwiftUI
import PhotosUI

struct JournalRecordView: View {
    @Binding var isViewPresented: Bool
    @Binding var isEditing: Bool
    @StateObject var journalViewModel: JournalViewModel
    
    @State var atDate: String = ""
    @State var infoText: String = ""
    @State var selectedImage: UIImage = UIImage(named: "empty") ?? UIImage()
    @State private var pickedPhoto: PhotosPickerItem?
    
    var body: some View {
        NavigationView {
            Form {
                Section("Datum") {
                    Text(atDate)
                }
                Section("Info") {
                    TextField("Info ke dni", text: $infoText, axis: .vertical)
                        .lineLimit(7...7)
                        .MultilineClearButton(text: $infoText)
                }
                Section("Fotka pro motivaci 🤳") {
                    if selectedImage.size != .zero {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                    }
                    
                    PhotosPicker("Vyberte fotku", selection: $pickedPhoto, matching: .images)
                        .onChange(of: pickedPhoto) {
                            Task {
                                if let data = try? await pickedPhoto?.loadTransferable(type: Data.self){
                                    if let image = UIImage(data: data){
                                        selectedImage = image
                                    }
                                }else{
                                    print("Error during photo selection")
                                }
                            }
                        }
                }
            }
            .onAppear{
                atDate = journalViewModel.getDateNowFormatted()
                if(isEditing){
                    atDate = journalViewModel.selectedJournalRecord!.formattedDate()
                    infoText = journalViewModel.selectedJournalRecord!.infoText
                    selectedImage = journalViewModel.selectedJournalRecord?.image ?? UIImage()
                }
            }
            .navigationBarItems(
                leading: Button("Zavřít") {
                    if(isEditing){
                        isEditing.toggle()
                    }
                    isViewPresented.toggle()
                },
                trailing: Button("Save") {
                    if(isEditing){
                        journalViewModel.updateJournalRecord(
                            infoText: infoText,
                            image: selectedImage
                        )
                        isEditing.toggle()
                    }else{
                        journalViewModel.addNewJournalRecord(
                            atDate: Date.now,
                            image: selectedImage,
                            infoText: infoText)
                    }
                    isViewPresented.toggle()
                })
        }
    }
}
/*
#Preview {
    NewJournalRecordView()
}
*/
