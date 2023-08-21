//
//  Icon.swift
//  TOTP
//
//  Created by Lucjan on 20/08/2023.
//

import SwiftUI
import SVGView

struct Icon: Codable {
    let slug: String
    let iconColor: SVGColor
    
    enum CodingKeys: CodingKey {
        case slug, iconColor
    }
    
    func encode(to encoder: Encoder) throws {
        var encoder = encoder.container(keyedBy: CodingKeys.self)
        
        try encoder.encode(iconColor.value, forKey: .iconColor)
        try encoder.encode(slug, forKey: .slug)
    }
    
    init(from decoder: Decoder) throws {
        let decoder = try decoder.container(keyedBy: CodingKeys.self)
        
        self.slug = try decoder.decode(String.self, forKey: .slug)
        self.iconColor = SVGColor(try decoder.decode(Int.self, forKey: .iconColor))
    }
    
    init(slug: String, iconColor: SVGColor) {
        self.slug = slug
        self.iconColor = iconColor
    }
}
