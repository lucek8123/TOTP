//
//  FileManager - documentsDirectory.swift
//  TOTPApp
//
//  Created by Lucjan on 08/04/2023.
//

import Foundation

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
