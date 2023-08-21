//
//  SVGView - fill.swift
//  TOTP
//
//  Created by Lucjan on 15/08/2023.
//

import Foundation
import SVGView


extension SVGView {
    func fill(color: SVGColor) -> SVGView {
        func tint(_ node: SVGNode, color: SVGColor) {
            if let group = node as? SVGGroup {
                for content in group.contents {
                    tint(content, color: color)
                }
            } else if let shape = node as? SVGShape {
                shape.fill = color
            }
        }
        guard let svg = self.svg else {
            return self
        }
        
        tint(svg, color: color)
        
        return self
    }
}
