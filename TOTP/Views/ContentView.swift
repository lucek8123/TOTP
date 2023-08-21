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
    
    @State private var settingsSheetShowing = false
    @State private var addSheetShowing = false
    
    @State private var accountName = ""
    @State private var url = ""
    
    @State private var addSelectionShowing = false
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
                        settingsSheetShowing = true
                    } label: {
                        Label("Settings", systemImage: "gear")
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
                            addSheetShowing = true
                        } label: {
                            Label("I have secret or URL", systemImage: "key.fill")
                        }
                    } label: {
                        Label("Add new one time password", systemImage: "plus")
                    }
                }
            }
            
            .sheet(isPresented: $addSheetShowing) {
                accountName = ""
                url = ""
            } content: {
                AddView(secret: $url, accountName: $accountName)
            }
            .sheet(isPresented: $settingsSheetShowing) {
                SettingsView()
            }
            .sheet(isPresented: $qrSheetShowing) {
                ZStack {
                    CodeScannerView(codeTypes: [.qr], showViewfinder: true, shouldVibrateOnSuccess: true) { result in
                        // more code to come
                        switch result {
                        case .success(let otp):
                            // Get accout name
                            accountName = getAccountName(otp.string)
                            url = URL(string: otp.string)?.absoluteString ?? ""
                            print(url)
                            withAnimation(.easeOut) {
                                qrSheetShowing = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    addSheetShowing = true
                                }
                            }
                            
                        case .failure(let error):
                            print("Error \(error)")
                        }
                    }
                    
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                qrSheetShowing = false
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.primary)
                                    .padding(5)
                                    .background(.thinMaterial)
                                    .clipShape(Circle())
                                    .padding()
                                    .accessibilityLabel("Close adding by qr")
                            }
                        }
                        Spacer()
                        Text("Scan QR Code")
                            .padding(5)
                            .background(.yellow)
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .circular))
                            .foregroundColor(.black)
                            .padding()
                            .font(.title3.bold())
                    }
                }
            }
        }
    }
    
    func getAccountName(_ str: String) -> String {
        guard let components = URLComponents(string: str) else {
            return ""
        }
        
        guard let issuerFromURL = components.queryItems?.first(where: { $0.name == "issuer" })?.value else {
            return ""
        }
        
        return issuerFromURL
    }
}


