//
//  OneTimePassword.swift
//  TOTPApp
//
//  Created by Lucjan on 20/03/2023.
//

import SwiftUI

class OneTimePassword: ObservableObject, Codable, Identifiable {
    var id = UUID()
    
    @Published var secret: String
    @Published var accountName: String
    @Published var icon: Icon?
    
    var digits = 6
    var timeInterval = 30
    var algorithm: OTPAlgorithm = .sha1
    
    var totp: TOTP {
        TOTP(secret: secret.base32DecodedData!, digits: digits, timeInterval: timeInterval, algorithm: algorithm)!
    }
    
    
    init(secret: String, accountName: String) {
        self.secret = secret
        self.accountName = accountName
    }
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case id
        case secret
        case accountName
        case icon
        case digits
        case timeInterval
        case algorithm
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(secret, forKey: .secret)
        try container.encode(accountName, forKey: .accountName)
        try container.encode(icon, forKey: .icon)
        try container.encode(digits, forKey: .digits)
        try container.encode(timeInterval, forKey: .timeInterval)
        try container.encode(algorithm, forKey: .algorithm)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        secret = try container.decode(String.self, forKey: .secret)
        accountName = try container.decode(String.self, forKey: .accountName)
        digits = try container.decode(Int.self, forKey: .digits)
        timeInterval = try container.decode(Int.self, forKey: .timeInterval)
        algorithm = try container.decode(OTPAlgorithm.self, forKey: .algorithm)
        
        icon =  try container.decodeIfPresent(Icon.self, forKey: .icon)
    }
}

extension OneTimePassword {
    static let example = OneTimePassword(secret: "7icdfllgx2ulxcmqn4ycjwwsmyp262xn", accountName: "Google")
}

extension OTPAlgorithm: Codable {
    enum CodingKeys: String, CodingKey {
        case sha1
        case sha256
        case sha512
    }
    
     public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let algorithmString = try container.decode(String.self)
        
        switch algorithmString {
        case CodingKeys.sha1.rawValue:
            self = .sha1
        case CodingKeys.sha256.rawValue:
            self = .sha256
        case CodingKeys.sha512.rawValue:
            self = .sha512
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid OTP algorithm: \(algorithmString)")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .sha1:
            try container.encode(CodingKeys.sha1.rawValue)
        case .sha256:
            try container.encode(CodingKeys.sha256.rawValue)
        case .sha512:
            try container.encode(CodingKeys.sha512.rawValue)
        }
    }
}

