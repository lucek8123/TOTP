//
//  SearchBarView.swift
//  TOTP
//
//  Created by Lucjan on 25/08/2023.
//

import SwiftUI
 
struct SearchBarView: View {
    @Binding var text: String
 
    @FocusState var isSearchFocused: Bool
    var body: some View {
        HStack {
 
            TextField("Search...", text: $text)
                .focused($isSearchFocused)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .transition(.move(edge: .trailing))
                .animation(.easeInOut(duration: 0.3))
 
            if isSearchFocused {
                Button(action: {
                    self.text = ""
                    isSearchFocused = false
                }) {
//                    Image(systemName: "xmark.circle")
                    Text("Cancel")
                }
                .padding(.all, 0)
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.easeInOut(duration: 0.3))
            }
        }
//        .padding(7)
//                .padding(.horizontal, 25)
//        .background(Color(.systemGray6))
//        .cornerRadius(8)
//        .padding(.horizontal, 10)
//        .onTapGesture {
//            self.isEditing = true
//        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack {
                SearchBarView(text: .constant(""))
            }
        }
    }
}
