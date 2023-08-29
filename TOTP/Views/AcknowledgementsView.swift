//
//  AcknowledgementsView.swift
//  TOTPApp
//
//  Created by Lucjan on 09/04/2023.
//

import SwiftUI

struct AcknowledgementsView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            List {
                Section("Dependencies") {
                    Text("Icons by [Simple Icons](https://github.com/simple-icons/simple-icons)")
                    Text("[SwiftOTP](https://github.com/lachlanbell/SwiftOTP) by [Lachlan Bell](https://github.com/lachlanbell/SwiftOTP)")
                    Text("[FaviconFinder](https://github.com/will-lumley/FaviconFinder) by [Will Lumley](https://github.com/will-lumley)")
                    Text("[CodeScanner](https://github.com/twostraws/CodeScanner) by [Paul Hudson](https://github.com/twostraws)")
                }
                Section("Sepecial Thanks") {
                    Text("Special thanks for both of my parents because they supported me through my programming journey. For my dad because he inspired me to programming and with him I started learning swift. \n\nFor Paul Hudson (@twostraws) because I learned SwiftUI with his free 100 Days with SwiftUI course.")
                }
            }
            .navigationTitle("Acknowledgements")
        }
    }
}


