//
//  SettingsView.swift
//  TOTPApp
//
//  Created by Lucjan on 09/04/2023.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            Form {
                
                NavigationLink {
                    AcknowledgementsView()
                } label: {
                    Text("Acknowledgements")
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
