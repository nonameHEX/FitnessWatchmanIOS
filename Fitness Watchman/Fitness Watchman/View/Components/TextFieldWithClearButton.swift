//
//  TextFieldClearButton.swift
//  Fitness Watchman
//
//  Created by Tomáš Kudera on 06.06.2024.
//

import SwiftUI

struct TextFieldWithClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        
        ZStack(alignment: .trailing) {
            content
            
            if !text.isEmpty {
                Image(systemName: "multiply.circle.fill")
                    .foregroundColor(.secondary)
                    .onTapGesture {
                        text = ""
                    }
                    .offset(x: 20)
            }
        }
    }
}

struct MultilineTextFieldWithClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        
        ZStack(alignment: .topTrailing) {
            content
            
            if !text.isEmpty {
                Image(systemName: "multiply.circle.fill")
                    .foregroundColor(.secondary)
                    .onTapGesture {
                        text = ""
                    }
                    .offset(x: 20)
                
            }
        }
    }
}

extension View {
    func ClearButton(text: Binding<String>) -> some View {
        modifier(TextFieldWithClearButton(text: text))
            .padding(.trailing, 12)
    }
    
    func MultilineClearButton(text: Binding<String>) -> some View {
        modifier(MultilineTextFieldWithClearButton(text: text))
            .padding(.trailing, 12)
    }
}
/*
#Preview {
    TextFieldClearButton()
}
*/
