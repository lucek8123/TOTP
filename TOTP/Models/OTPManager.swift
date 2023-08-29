//
//  OTPManager.swift
//  TOTPApp
//
//  Created by Lucjan on 08/04/2023.
//

import Foundation
import CryptoKit

class OTPManager: ObservableObject {
    @Published var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    @Published var passwords: [OneTimePassword]
    let path = FileManager.documentsDirectory.appendingPathComponent("OneTimePasswords")
    
    static let shared = OTPManager()
    
//    let symmetricKey = SymmetricKey(data: SHA256.hash(data: "testistest".dataUsingUTF8StringEncoding))
    
    private init() {
        do {
//            let data = try Data(contentsOf: path)
//            let sealedBox = try AES.GCM.SealedBox(combined: data)
//            let decrypted = try AES.GCM.open(sealedBox, using: symmetricKey)
//            print(String(data: decrypted, encoding: .utf8))
//
//            let decoder = JSONDecoder()
//            passwords = try decoder.decode([OneTimePassword].self, from: decrypted)
            passwords = try Bundle.main.decode([OneTimePassword].self, from: path)
        } catch {
            passwords = []
        }
    }
    
    func save() {
        do {
//            let encoder = JSONEncoder()
//            encoder.outputFormatting = .withoutEscapingSlashes
//            let encoded = try encoder.encode(passwords)
//            if let encrypted = try AES.GCM.seal(encoded, using: symmetricKey).combined {
//                try encrypted.write(to: path, options: [.atomic, .completeFileProtection])
//            } else {
//                throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: ""))
//            }
            let data = try JSONEncoder().encode(passwords)
            try data.write(to: path, options: [.completeFileProtection])
        } catch {
            print("Unable to save data \n \(error)")
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
    
    static var icons: [Icon] {
        guard let url = Bundle.main.url(forResource: "simple-icons.json", withExtension: nil) else {
            fatalError("Failed to locate simple-icons.json in bundle.")
        }
        
        do {
            return try Bundle.main.decode([Icon].self, from: url)
        } catch {
            fatalError("Failed to decode simple-icons.json - that should not happen. \n \(error.localizedDescription)")
        }
    }
}
