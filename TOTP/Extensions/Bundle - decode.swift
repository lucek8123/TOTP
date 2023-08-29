//
//  loadDocument.swift
//  TOTPApp
//
//  Created by Lucjan on 08/04/2023.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from url: URL, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) throws -> T {

        let data = try Data(contentsOf: url)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        return try decoder.decode(T.self, from: data)
    }
}
