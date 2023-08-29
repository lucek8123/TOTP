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
            }
            .navigationTitle("Acknowledgements")
        }
    }
}


