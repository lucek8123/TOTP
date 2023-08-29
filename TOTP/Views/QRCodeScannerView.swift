//
//  QRCodeScannerView.swift
//  TOTP
//
//  Created by Lucjan on 22/08/2023.
//

import SwiftUI
import CodeScanner

struct QRCodeScannerView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var accountName: String
    @Binding var url: String?
    
    var body: some View {
        ZStack {
            CodeScannerView(codeTypes: [.qr], showViewfinder: true, shouldVibrateOnSuccess: true) { result in
                switch result {
                case .success(let otp):
                    // Get accout name
                    accountName = getAccountName(otp.string)

                    withAnimation(.easeOut) {
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            url = URL(string: otp.string)?.absoluteString ?? ""
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
                        dismiss()
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

struct QRCodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeScannerView(accountName: .constant(""), url: .constant(""))
    }
}
