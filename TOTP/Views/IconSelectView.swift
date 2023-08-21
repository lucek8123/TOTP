//
//  IconSelectView.swift
//  TOTP
//
//  Created by Lucjan on 14/08/2023.
//

import SwiftUI
import SVGView

struct IconSelectView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var icon: Icon?
    
    @State private var isDefaultIconColor = true
    @State private var iconColor: SVGColor = .init(color: .cyan)
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal) {
                    HStack {
                        Text("Default")
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(.thinMaterial)
                            .clipShape(Capsule())
                            .onTapGesture {
                                isDefaultIconColor = true
                            }
                        Group {
                            ColorButton(.black)
                            ColorButton(.red)
                            ColorButton(.blue)
                            ColorButton(.deepskyblue)
                            ColorButton(.green)
                            ColorButton(.plum)
                            ColorButton(.burlywood)
                            ColorButton(.salmon)
                            ColorButton(.orange)
                            ColorButton(.mintcream)
                        }
//                        ColorPicker("", selection: $iconColor, supportsOpacity: false)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 125))]) {
                        ForEach(SimpleIcon.icons, id: \.slug) { icon in
                            VStack {
                                icon.image
                                    .fill(color: isDefaultIconColor ? .init(hex: icon.hex) : iconColor)
                                    .frame(width: 64, height: 64)
                                Text(icon.title)
                            }
                            .frame(width: 125)
                            .padding(.vertical)
                            .background(.regularMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onTapGesture {
                                if isDefaultIconColor {
                                    self.icon = Icon(slug: icon.slug, iconColor: SVGColor(hex: icon.hex))
                                } else {
                                    self.icon = Icon(slug: icon.slug, iconColor: iconColor)
                                }
                                print(self.icon?.slug)
                                dismiss()
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Select Icon")
        }
    }
    
    func ColorButton(_ color: SVGColor.Colors) -> some View {
        Button {
            isDefaultIconColor = false
            iconColor = SVGColor(color: color)
        } label: {
            Circle()
                .foregroundColor(SVGColor(color: color).toSwiftUI())
                .frame(width: 32, height: 32)
        }

    }
}

struct IconSelectView_Previews: PreviewProvider {
    static var previews: some View {
        IconSelectView(icon: .constant(nil))
    }
}
