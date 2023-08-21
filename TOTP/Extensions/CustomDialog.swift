//
//  CustomDialog.swift
//  TOTPApp
//
//  Created by Lucjan on 01/05/2023.
//

import Foundation
import SwiftUI

// Solution from StackOverflow 
extension View {
    func customDialog<V: View>(isPresented: Binding<Bool>, @ViewBuilder actions: @escaping () -> V) -> some View {
        return self.modifier(CustomDialog(isPresented: isPresented, actions: actions))
    }
}

struct CustomDialog<V>: ViewModifier where V: View {
    @Binding var isPresented: Bool
    @ViewBuilder let actions: () -> V
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            ZStack(alignment: .bottom) {
                if isPresented {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onTapGesture {
                            isPresented = false
                        }
                        .transition(.opacity)
                    
                    VStack {
                        GroupBox {
                            actions()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        GroupBox {
                            Button("Cancel", role: .cancel) {
                                isPresented = false
                            }
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .font(.title3)
                    .padding(8)
                    .transition(.move(edge: .bottom))
                }
            }
            .animation(.easeInOut(duration: 0.1), value: isPresented)
            .drawingGroup()
        }
    }
}
