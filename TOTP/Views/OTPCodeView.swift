//
//  OTPCodeView.swift
//  TOTPApp
//
//  Created by Lucjan on 20/03/2023.
//

import SwiftUI
import SVGView

struct OTPCodeView: View {
    @EnvironmentObject var manager: OTPManager
    @ObservedObject var otp: OneTimePassword

    @State private var renewIn = 0
    @State private var OTPString: String = ""
    
    @State private var editViewShowing = false
    
    var body: some View {
        HStack {
            otp.icon?.image
                .fill(color: otp.icon?.iconColor ?? .black)
                .frame(width: 50, height: 50)
            if otp.icon != nil {
                Divider()
            }
            VStack(alignment: .leading, spacing: 0) {
                Text(otp.accountName)
                    .font(.body)
                HStack {
                    Text(OTPString.prefix(OTPString.count / 2))
                    Circle()
                        .scaledToFit()
                        .frame(width: 7.5)
                    Text(OTPString.suffix(OTPString.count / 2))
                }
                .foregroundColor(.primary)
                .font(.system(size: 30, weight: .bold, design: .monospaced))
            }
            Spacer()
            Gauge(value: Double(renewIn), in: 0...Double(otp.timeInterval)) {
                Text("\(renewIn)")
                    .transaction { transaction in
                        transaction.animation = nil
                    }
            }
            .gaugeStyle(ThinGauge())
            .tint(renewIn > 5 ? .blue : .red)
        }
        .padding()
        .contextMenu {
            NavigationLink {
                OTPDetailView(otp: otp)
                    .environmentObject(manager)
            } label: {
                Label("Details", systemImage: "info.circle")
            }
            Button {
                editViewShowing = true
            } label: {
                Label("Edit", systemImage: "square.and.pencil")
            }
        }
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onReceive(manager.timer) { _ in
            updateCode()
        }
        .sheet(isPresented: $editViewShowing) {
            EditView(otp: otp)
        }
    }
    
    func updateCode() {
        OTPString = otp.totp.generate(time: Date.now) ?? ""
        withAnimation(.default) { 
                        renewIn = otp.timeInterval - Int(Date.now.timeIntervalSince1970) % otp.timeInterval
        }
    }
    
    init(otp: OneTimePassword) {
        self.otp = otp
        self._OTPString = State(initialValue: otp.totp.generate(time: Date.now) ?? "")
        self._renewIn = State(initialValue: otp.timeInterval - Int(Date.now.timeIntervalSince1970) % otp.timeInterval)
    }
}

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTPCodeView(otp: .example)
            .environmentObject(OTPManager.shared)
            .padding()
    }
}
