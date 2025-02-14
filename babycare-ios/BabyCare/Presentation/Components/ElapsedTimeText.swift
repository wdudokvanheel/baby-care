import Combine
import SwiftUI

struct ElapsedTimeText: View {
    let startDate: Date
    @State private var currentTime = Date()
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    var body: some View {
        Text(timeElapsed(from: startDate, to: currentTime))
            .onReceive(timer) { input in
                currentTime = input
            }
            .onDisappear {
                timer.upstream.connect().cancel()
            }
    }

    private func timeElapsed(from startDate: Date, to currentDate: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: startDate, to: currentDate)
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        return String(format: "%02d:%02d since last feeding", hours, minutes)
    }
}
