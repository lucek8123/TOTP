//
//  AdvancedSettingsView.swift
//  TOTPApp
//
//  Created by Lucjan on 17/04/2023.
//

import SwiftUI

struct AdvancedSettingsView: View {
    @Binding var digits: Int
    @Binding var timeInterval: Int
    @Binding var algorithm: OTPAlgorithm
    
    var body: some View {
        Form {
            Section {
                Stepper(value: $digits, in: 6...8) {
                    Text("Digits: \(digits)")
                }
                HStack {
                    Text("Time Interval: ")
                    TextField("", value: $timeInterval, format: .number)
                        .keyboardType(.numberPad)
                }
                Picker("Algorithm", selection: $algorithm) {
                    Text("SHA1")
                        .tag(OTPAlgorithm.sha1)
                    Text("SHA256")
                        .tag(OTPAlgorithm.sha256)
                    Text("SHA512")
                        .tag(OTPAlgorithm.sha512)
                }
                .pickerStyle(.menu)
            } footer: {
                Text("If you don't know your settings, don't change these.")
            }
        }
        .navigationTitle("Advanced Settings")
    }
}


