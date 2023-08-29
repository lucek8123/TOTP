//
//  OTPDetailView.swift
//  TOTPApp
//
//  Created by Lucjan on 18/04/2023.
//

import SwiftUI

struct OTPDetailView: View {
    @EnvironmentObject var manager: OTPManager
    @ObservedObject var otp: OneTimePassword
    
    @State private var code: String
    @State private var renewIn: Int
    @Environment(\.dismiss) var dismiss
    
    @State private var deleteConfirmationShowed = false
    @State private var editSheetShowing = false
    @State private var copiedAlertShowing = false

    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text(code.prefix(code.count / 2))
                        Circle()
                            .scaledToFit()
                            .frame(width: 10)
                        Text(code.suffix(code.count / 2))
                        Spacer()
                    }
                    .font(.title.bold())
                    .monospacedDigit()
                    .foregroundColor(Color.primary)
                    Spacer()
                    Gauge(value: Double(renewIn), in: 0...30) {
                        Text("\(renewIn)")
                            .foregroundColor(.primary)
                            .transaction { transaction in
                                transaction.animation = nil
                            }
                    }
                    .gaugeStyle(.linearCapacity)
                    .foregroundColor(renewIn > 5 ? .blue : .red)
                    .tint(renewIn > 5 ? .blue : .red)
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.codeStroke)
                )
                .padding()
                .onTapGesture {
                    UIPasteboard.general.string = code
                    copiedAlertShowing = true
                }
                Group {
                    HStack {
                        Text("Secret: ")
                        Spacer()
                        Text("\(otp.secret)")
                    }
                    
                    VStack {
                        HStack {
                            Text("Algorithm: ")
                            Spacer()
                            Text("\(algorithm)")
                        }
                        Divider()
                        HStack {
                            Text("Time Interval: ")
                            Spacer()
                            Text("\(otp.timeInterval)")
                        }
                        Divider()
                        HStack {
                            Text("Digits: ")
                            Spacer()
                            Text("\(otp.digits)")
                        }
                    }
                    
                    Button(role: .destructive) {
                        deleteConfirmationShowed = true
                    } label: {
                        HStack {
                            Text("Delete")
                            Spacer()
                        }
                    }

                }
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding([.horizontal, .bottom])
            }
        }
        .navigationTitle(otp.accountName)
        .onReceive(manager.timer) { _ in
            updateCode()
        }
        .confirmationDialog("Permanently delete this item?", isPresented: $deleteConfirmationShowed) {
            Button("Delete", role: .destructive) {
                delete()
            }
        } message: {
            Text("You can't undo this action.")
        }
        .sheet(isPresented: $editSheetShowing) {
            EditView(otp: otp)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    editSheetShowing = true
                }
            }
        }
        .copyAlert(showing: $copiedAlertShowing)
    }
    
    var algorithm: String {
        switch otp.algorithm {
            case .sha1:
                return "SHA 1"
            case .sha256:
                return "SHA 256"
            case .sha512:
                return "SHA 512"
        }
    }
    
    func delete() {
        manager.delete(otp: otp)
        manager.save()
        dismiss()
    }
    
    func updateCode() {
        code = otp.totp.generate(time: Date.now)!
        withAnimation(.default) { 
            renewIn = otp.timeInterval - Int(Date.now.timeIntervalSince1970) % otp.timeInterval
        }
    }
    
    init(otp: OneTimePassword) {
        self.otp = otp
        self._code = State(initialValue: otp.totp.generate(time: Date.now)!)
        self._renewIn = State(initialValue: otp.timeInterval - Int(Date.now.timeIntervalSince1970) % otp.timeInterval)
    }
}

struct OTPDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            OTPDetailView(otp: .example)
                .environmentObject(OTPManager.shared)

        }
    }
}
