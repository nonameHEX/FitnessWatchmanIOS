//
//  JournalView.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 07.05.2024.
//

import SwiftUI

struct JournalView: View {
    @StateObject var journalViewModel: JournalViewModel
    
    @State var isJournalRecordViewPresented = false
    @State var isEditingJournalRecord = false
    @State var isImageFullScreen = false
    @State var selectedImage: UIImage? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                List(journalViewModel.journalRecords) { record in
                    VStack{
                        HStack {
                            HStack{
                                Text("\(record.formattedDate())")
                                Spacer()
                            }.overlay(
                                Rectangle()
                                    .stroke(Color.blue, lineWidth: 0)
                            )
                            .onTapGesture { }
                            
                            Button(action: {
                                isEditingJournalRecord.toggle()
                                isJournalRecordViewPresented.toggle()
                                journalViewModel.selectedJournalRecord = record
                            }) {
                                Text("📝")
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.blue, lineWidth: 1)
                                    )
                            }
                            
                        }
                        HStack {
                            if record.image.size != .zero {
                                Image(uiImage: record.image)
                                        .resizable()
                                        .scaledToFit()
                                        .onTapGesture {
                                            selectedImage = record.image
                                            isImageFullScreen.toggle()
                                        }
                                        .cornerRadius(10)
                                } else {
                                    Text("Žádný obrázek")
                                        .foregroundColor(.gray)
                                }
                                
                        }
                        
                        HStack {
                            Text("\(record.infoText)")
                            Spacer()
                        }.overlay(
                            Rectangle()
                                .stroke(Color.blue, lineWidth: 0)
                        )
                        .onTapGesture { }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            journalViewModel.deleteJournalRecord(record: record)
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            .navigationTitle("🤳 Deník")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Přidat") {
                        isJournalRecordViewPresented.toggle()
                    }
                }
            }
            .sheet(isPresented: $isJournalRecordViewPresented){
                JournalRecordView(isViewPresented: $isJournalRecordViewPresented,
                                     isEditing: $isEditingJournalRecord, journalViewModel: journalViewModel)
            }
            .onAppear {
                journalViewModel.FetchAllJournalRecords()
            }
        }
    }
}

/*
#Preview {
    JournalView()
}
*/
