import SwiftUI

struct ThinGauge: GaugeStyle {
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geo in
            ZStack {
                Circle()
                    .stroke(lineWidth: geo.size.height * 0.1)
                    .fill(.tint)
                    .opacity(0.5)
                Circle()
                    .trim(from: 0, to: 1 * configuration.value)
                    .stroke(style: .init(lineWidth: geo.size.height * 0.1, lineCap: .round, lineJoin: .round))
                    .fill(.tint)
                    .opacity(0.5)
                    .rotationEffect(.degrees(-90))
                configuration.label
//                    .font(.custom("SF-Pro", size: 55, relativeTo: .title))
//                    .bold()
//                    .fontDesign(.rounded)
                    .font(.system(size: geo.size.height * 0.5, weight: .bold, design: .rounded))
                    .foregroundColor(.gray)
                
            }
        }
        .frame(width: 50, height: 50)
    }
}

struct ThinGauge_Previews: PreviewProvider {
    static var previews: some View {
        Gauge(value: 23, in: 0...30) {
            Text("23")
        }
        .gaugeStyle(ThinGauge())
//        .gaugeStyle(.accessoryCircularCapacity)
//        .frame(width: 100, height: 100)
    }
}
