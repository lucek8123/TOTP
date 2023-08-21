//
//  AddView.swift
//  TOTPApp
//
//  Created by Lucjan on 08/04/2023.
//

import SwiftUI
import CodeScanner
import SVGView

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var secret: String
    @Binding var accountName: String
    
    @State private var digits = 6
    @State private var timeInterval = 30
    @State private var algorithm: OTPAlgorithm = .sha1
    
    @State private var icon: Icon? = nil
    @State private var selectIconSheetPresenting = false
    
    var url: URL? {
        return URL(string: secret)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Account name") {
                    TextField("Account name here", text: $accountName)
                    
                }
                Section("Verification Code URL or Secret") {
                    TextField("Verification Code URL or Secret here", text: $secret)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                }
                Section("Icon") {
                    HStack {
                        Text("Select Icon")
                        Spacer()
                        iconView
                            .frame(width: 32, height: 32)
                    }
                    .onTapGesture {
                        selectIconSheetPresenting = true
                    }
                    .accessibilityAddTraits(.isButton)
                }
                NavigationLink {
                    AdvancedSettingsView(digits: $digits, timeInterval: $timeInterval, algorithm: $algorithm)
                } label: {
                    Text("Advanced Settings")
                }
            }
            .navigationTitle("Add OTP")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        add()
                    }
                    .disabled(secret.isEmpty ||
                              accountName.isEmpty ||
                              timeInterval < 1 ||
                              url == nil ||
                              secret.base32DecodedData == nil)

                }
            }
            .sheet(isPresented: $selectIconSheetPresenting) {
                IconSelectView(icon: $icon)
            }
        }
    }
    
    var iconView: SVGView? {
        guard let slug = icon?.slug else {
            return nil
        }
        
        guard let url = Bundle.main.url(forResource: slug, withExtension: "svg", subdirectory: "icons") else {
            fatalError("Failed to load icon \(slug).svg")
        }
        
        return SVGView(contentsOf: url)
            .fill(color: icon?.iconColor ?? .black)
    }
    
    func getSecret() -> String? {
        guard let url else { return nil }
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        guard let secretFromURL = components?.queryItems?.first(where: { $0.name == "secret" })?.value else {
            return nil
        }
        
        return secretFromURL
    }
    
    func getAlgorithm() -> OTPAlgorithm? {
        guard let url else { return nil }
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        guard let algorithmFromURL = components?.queryItems?.first(where: { $0.name == "algorithm" })?.value else {
            return nil
        }
        
        let algorithmDecoded = OTPAlgorithm.CodingKeys(stringValue: algorithmFromURL)
        
        switch algorithmDecoded {
            case .sha1:
                return OTPAlgorithm.sha1
            case .sha256:
                return OTPAlgorithm.sha256
            case .sha512:
                return OTPAlgorithm.sha512
            default:
                return nil
        }
    }
    
    func getDigits() -> Int? {
        guard let url else { return nil }
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        guard let secretFromURL = components?.queryItems?.first(where: { $0.name == "digits" })?.value else {
            return nil
        }
        return Int(secretFromURL)
    }
    
    func getPeriod() -> Int? {
        guard let url else { return nil }
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                
        guard let periodFromURL = components?.queryItems?.first(where: { $0.name == "period" })?.value else {
            return nil
        }
        
        guard let period = Int(periodFromURL) else {
            return nil
        }
        
        return period
    }
    
    func add() {
        let otp = OneTimePassword(secret: secret, accountName: accountName)
        
        if let secretFromURL = getSecret() {
            otp.secret = secretFromURL
        } else {
            guard secret.base32DecodedData != nil else {
                print("Can't decode data")
                return
            }
            otp.secret = secret.lowercased()
        }
        
        otp.accountName = accountName
        
        otp.digits = getDigits() ?? digits
        otp.timeInterval = getPeriod() ?? timeInterval
        otp.algorithm = getAlgorithm() ?? algorithm
        
        otp.icon = icon
        
        OTPManager.shared.add(otp)
        OTPManager.shared.save()
        dismiss()
    }
}


