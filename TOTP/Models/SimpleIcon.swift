//
//  SimpleIcon.swift
//  TOTP
//
//  Created by Lucjan on 14/08/2023.
//

import SwiftUI
import SVGView

struct SimpleIcon: Decodable {
    let title: String
    let slug: String
    let hex: String
    
    var image: SVGView {
        guard let url = Bundle.main.url(forResource: slug, withExtension: "svg", subdirectory: "icons") else {
            fatalError("Failed to load icon \(slug).svg")
        }
        
        return SVGView(contentsOf: url)
    }
    
    enum CodingKeys: CodingKey {
        case title, hex, source, slug
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
                
        if let imageName = try container.decodeIfPresent(String.self, forKey: .slug) {
            slug = imageName
        } else {
            let withoutSpecial = title.lowercased()
                .replacingOccurrences(of: ".", with: "dot")
                .replacingOccurrences(of: "&", with: "and")
                .replacingOccurrences(of: "+", with: "plus")
                .replacingOccurrences(of: #"à|á|â|ã|ä"#, with: "a", options: .regularExpression)
                .replacingOccurrences(of: #"ç|č|ć"#, with: "c", options: .regularExpression)
                .replacingOccurrences(of: #"è|é|ê|ë"#, with: "e", options: .regularExpression)
                .replacingOccurrences(of: #"ì|í|î|ï"#, with: "i", options: .regularExpression)
                .replacingOccurrences(of: #"ñ|ň|ń"#, with: "n", options: .regularExpression)
                .replacingOccurrences(of: #"ò|ó|ô|õ|ö"#, with: "o", options: .regularExpression)
                .replacingOccurrences(of: #"š|ś"#, with: "s", options: .regularExpression)
                .replacingOccurrences(of: #"ù|ú|û|ü"#, with: "u", options: .regularExpression)
                .replacingOccurrences(of: #"ý|ÿ"#, with: "y", options: .regularExpression)
                .replacingOccurrences(of: #"ž|ź|ż"#, with: "z", options: .regularExpression)
            
            let regex = try! NSRegularExpression(pattern: "[^a-zA-Z0-9]+", options: .caseInsensitive)
            slug = regex.stringByReplacingMatches(in: withoutSpecial, range: NSRange(location: 0, length: title.count), withTemplate: "").lowercased()
        }
        
        hex = try container.decode(String.self, forKey: .hex)
    }
    
    static var icons: [SimpleIcon] {
        guard let url = Bundle.main.url(forResource: "simple-icons.json", withExtension: nil) else {
            fatalError("Failed to locate simple-icons.json in bundle.")
        }
        
        do {
            return try Bundle.main.decode([SimpleIcon].self, from: url)
        } catch {
            fatalError("Failed to decode simple-icons.json - that should not happen. \n \(error.localizedDescription)")
        }
    }
}
