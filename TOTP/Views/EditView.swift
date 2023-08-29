//
//  EditView.swift
//  TOTPApp
//
//  Created by Lucjan on 16/04/2023.
//

import SwiftUI
import SVGView

struct EditView: View {
    @EnvironmentObject var manager: OTPManager
    @ObservedObject var otp: OneTimePassword
    @Environment(\.dismiss) var dismiss
    
    @State private var accountName: String
    @State private var secret: String
    
    @State private var digits: Int
    @State private var timeInterval: Int
    @State private var algorithm: OTPAlgorithm
    
    @State private var icon: Icon?
    @State private var selectIconSheetPresenting = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("Account name") {
                        TextField("Edit Account Name", text: $accountName)
                    }
                    Section("Verification code url or secret") {
                        TextField("Edit Secret", text: $secret)
                    }
                    Section("Icon") {
                        HStack {
                            Text("Select Icon")
                            Spacer()
                            icon?.image
                                .fill(color: icon?.iconColor ?? .black)
                                .frame(width: 32, height: 32)
                        }
                        .onTapGesture {
                            selectIconSheetPresenting = true
                        }
                        .accessibilityAddTraits(.isButton)
                    }
                    Section("Advanced Settings") {
                        NavigationLink("Advanced Settings") {
                            AdvancedSettingsView(digits: $digits, timeInterval: $timeInterval, algorithm: $algorithm)
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            save()
                        }
                        .disabled(secret.isEmpty ||
                                  accountName.isEmpty ||
                                  (URL(string: secret) == nil && secret.base32DecodedData == nil))
                    }
                }
                .navigationTitle("Edit Account")
                .sheet(isPresented: $selectIconSheetPresenting) {
                    IconSelectView(icon: $icon)
                }
            }
        }
    }
    
    
    func save() {
        otp.accountName = accountName
        otp.secret = secret
        otp.digits = digits
        otp.timeInterval = timeInterval
        otp.algorithm = algorithm
        otp.icon = icon
        
        manager.save()
        dismiss()
    }
    
    init(otp: OneTimePassword) {
        self.otp = otp
        self._accountName = .init(initialValue: otp.accountName)
        self._secret = .init(initialValue: otp.secret)
        self._digits = .init(initialValue: otp.digits)
        self._timeInterval = .init(initialValue: otp.timeInterval)
        self._algorithm = .init(initialValue: otp.algorithm)
        self._icon = .init(initialValue: otp.icon)
    }
}


