//
//  IconView.swift
//  TOTP
//
//  Created by Lucjan on 20/08/2023.
//

import SwiftUI
import SVGView

struct IconView: View {
    var icon: Icon
    
    var body: some View {
        iconView
    }
    
    var iconView: SVGView {
        guard let url = Bundle.main.url(forResource: icon.slug, withExtension: "svg", subdirectory: "icons") else {
            fatalError("There is no image named \(icon.slug).svg in bundle)")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Couldn't decode file \(icon.slug).svg")
        }
        
        let view = SVGView(data: data)
        
        return view
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView(icon: Icon(slug: "apple", iconColor: .black))
    }
}
