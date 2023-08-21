//
//  OTPManager.swift
//  TOTPApp
//
//  Created by Lucjan on 08/04/2023.
//

import Foundation

class OTPManager: ObservableObject {
    @Published var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    @Published var passwords: [OneTimePassword]
    let path = FileManager.documentsDirectory.appendingPathComponent("OneTimePasswords")
    
    static let shared = OTPManager()
    
    private init() {
        do {
            passwords = try Bundle.main.loadDocument(from: path)
        } catch {
            passwords = []
        }
    }
    
    func save() {
        do {
            let encoded = try JSONEncoder().encode(passwords)
            try encoded.write(to: path, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data")
        }
    }
    
    func add(_ otp: OneTimePassword) {
        passwords.append(otp)
    }
    
    func delete(otp: OneTimePassword) {
        passwords.removeAll {
            $0.id == otp.id
        }
    }
    
    static func genCodeWithDot(string: String, withSpaces: Bool = true) -> String {
        let dotIndex = string.index(string.startIndex, offsetBy: string.count / 2) // Calculate index for dot insertion
        var stringWithDot = string
        if withSpaces {
            stringWithDot.insert(contentsOf: " • ", at: dotIndex)
        } else {
            stringWithDot.insert("•", at: dotIndex)
        }
        return stringWithDot
    }
}
