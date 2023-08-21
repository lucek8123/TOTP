//
//  loadDocument.swift
//  TOTPApp
//
//  Created by Lucjan on 08/04/2023.
//

import Foundation

extension Bundle {
    enum LoadDocumentError: Error {
        case failedLoadData
        case failedDecodeData
    }
    
    func loadDocument<T: Codable>(from url: URL) throws -> T {
        guard let data = try? Data(contentsOf: url) else {
            throw LoadDocumentError.failedLoadData
        }
        
        let decoder = JSONDecoder()
        let formater = DateFormatter()
        formater.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formater)
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            print("D")
            throw LoadDocumentError.failedDecodeData
        }
        
        return loaded
    }
    
    func decode<T: Decodable>(_ type: T.Type, from file: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}
