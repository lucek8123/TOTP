import SwiftUI

struct ThinGauge: GaugeStyle {
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geo in 
            ZStack {
                Circle()
                    .stroke(lineWidth: geo.size.height * 0.1)
                    .foregroundColor(.blue.opacity(0.5))
                Circle()
                    .trim(from: 0, to: 1 * configuration.value)
                    .stroke(style: .init(lineWidth: geo.size.height * 0.1, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.blue.opacity(0.5))
                    .rotationEffect(.degrees(-90))
                configuration.label
                    .font(.system(size: geo.size.height * 0.5, weight: .bold, design: .rounded))
                    .foregroundColor(.gray)
                
            }
        }
//        .frame(width: 100, height: 100)
    }
}

struct ThinGauge_Previews: PreviewProvider {
    static var previews: some View {
        Gauge(value: 23, in: 0...30) {
            Text("23")
        }
        .gaugeStyle(ThinGauge())
        .frame(width: 100, height: 100)
    }
}
