//
//  String - Identifable.swift
//  TOTP
//
//  Created by Lucjan on 22/08/2023.
//

import Foundation

extension String: Identifiable {
    public var id: String {
        return self
    }
}
