//
//  Color - hex.swift
//  TOTP
//
//  Created by Lucjan on 14/08/2023.
//

import SwiftUI
import SVGView

extension SVGColor {
    enum Colors: String {
        case white, silver, gray, black, red, maroon, yellow, olive, lime, green, aqua, teal, blue, navy, purple, aliceblue, antiquewhite, aquamarine, azure, beige, bisque, blanchedalmond, blueviolet, brown, burlywood, cadetblue, chartreuse, chocolate, coral, cornflowerblue, cornsilk, crimson, cyan, orange, pink, mintcream, salmon, plum, deepskyblue
    }
    
    convenience init(color: Colors) {
        self.init(SVGColor.by(name: color.rawValue)!.value)
    }
}
