import SwiftUI

struct CopyAlert: ViewModifier {
    @Binding var alertShowing: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                Image(systemName: "checkmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                Text("Copied to Clipboard!")
                    .font(.title2)
            }
            .padding()
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .opacity(alertShowing ? 1 : 0)
            .animation(.easeInOut(duration: 0.25), value: alertShowing)
        }
        .onChange(of: alertShowing) { value in
            if value == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    alertShowing = false 
                }
            }
        }
    }
}

extension View {
    func copyAlert(showing: Binding<Bool>) -> some View {
        self
            .modifier(CopyAlert(alertShowing: showing))
    }
}

