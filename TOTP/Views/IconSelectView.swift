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
    
    @State private var selectedIcon: Icon?
    
    @State private var isDefaultIconColor = true
    @State private var iconColor: SVGColor = .init(color: .cyan)
    
    @State private var search = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(text: $search)
                    .padding(.horizontal, 5)
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
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                }
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 125))]) {
                        ForEach(filtredIcons, id: \.slug) { icon in
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
                                withAnimation {
                                    if selectedIcon?.slug == icon.slug {
                                        selectedIcon = nil
                                    } else {
                                        if isDefaultIconColor {
                                            selectedIcon = Icon(title: icon.title, slug: icon.slug, iconColor: SVGColor(hex: icon.hex))
                                        } else {
                                            selectedIcon = Icon(title: icon.title, slug: icon.slug, iconColor: iconColor)
                                        }
                                    }
                                }
                            }
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.codeStroke, lineWidth: icon.slug == self.selectedIcon?.slug && self.selectedIcon?.slug != nil ? 2 : 0)
                            }
                                
                        }
                    }
                    .padding()
                }
            
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        icon = selectedIcon
                        dismiss()
                    }

                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .navigationTitle("Select Icon")
//            .searchable(text: $search)
        }
    }
    
    var filtredIcons: [SimpleIcon] {
        if search.isEmpty {
            return SimpleIcon.icons
        }
        
        return SimpleIcon.icons.filter { icon in
            icon.title.lowercased().hasPrefix(search.lowercased())
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
    
    init(icon: Binding<Icon?>) {
        _icon = icon
        _selectedIcon = State(initialValue: icon.wrappedValue)
    }
}

struct IconSelectView_Previews: PreviewProvider {
    static var previews: some View {
        IconSelectView(icon: .constant(nil))
    }
}
