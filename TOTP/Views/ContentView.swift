//
//  ContentView.swift
//  TOTPApp
//
//  Created by Lucjan on 19/03/2023.
//

import SwiftUI
import CodeScanner

struct ContentView: View {
    @StateObject var otpManager = OTPManager.shared
    @Environment(\.dismiss) var dismiss
    
    @State private var acknowledgementsSheetShowing = false
    @State private var addSheetShowing = false
    
    @State private var accountName = ""
    @State private var url: String?
    
    @State private var qrSheetShowing = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 350), spacing: 5, alignment: .topLeading)]) {
                    ForEach(otpManager.passwords) { otp in
                        OTPCodeView(otp: otp)
                            .environmentObject(otpManager)
                    }
                }
            }
            .padding()
            .navigationTitle("Codes")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        acknowledgementsSheetShowing = true
                    } label: {
                        Label("Acknowledgements", systemImage: "text.book.closed")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            qrSheetShowing = true
                        } label: {
                            Label("I have qr code", systemImage: "qrcode")
                        }
                        Button {
                            url = ""
                        } label: {
                            Label("I have secret or URL", systemImage: "key.fill")
                        }
                    } label: {
                        Label("Add new one time password", systemImage: "plus")
                    }
                }
            }
            .sheet(item: $url) {
                accountName = ""
            } content: { url in
                AddView(url: url, accountName: accountName)
            }
            .sheet(isPresented: $acknowledgementsSheetShowing) {
                AcknowledgementsView()
            }
            .sheet(isPresented: $qrSheetShowing) {
                QRCodeScannerView(accountName: $accountName, url: $url)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

