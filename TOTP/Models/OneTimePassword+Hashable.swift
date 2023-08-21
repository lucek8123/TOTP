import SwiftUI

extension OneTimePassword: Hashable {
    static func ==(lhs: OneTimePassword, rhs: OneTimePassword) -> Bool {
        return lhs.accountName == rhs.accountName &&
        lhs.secret == rhs.secret &&
        lhs.algorithm == rhs.algorithm &&
        lhs.digits == rhs.digits &&
        lhs.timeInterval == rhs.timeInterval

    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(accountName)
        hasher.combine(secret)
        hasher.combine(algorithm)
        hasher.combine(digits)
        hasher.combine(timeInterval)

    }
}
