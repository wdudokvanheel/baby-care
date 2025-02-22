import Foundation
import SwiftUI

struct RefreshingElapsedTimeText: View {
    @State
    private var elapsed: Int

    let text: String
    let date: Date

    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    init(_ text: String, _ date: Date) {
        self.text = text
        self.date = date
        _elapsed = State(initialValue: max(0, Int(Date().timeIntervalSince(date))))
    }

    var body: some View {
        Text("\(text) \(elapsed.formatAsDurationString(excludeHours: true))")
            .onReceive(timer) { _ in
                updateSleepDuration()
            }
    }

    private func updateSleepDuration() {
        elapsed = max(0, Int(Date().timeIntervalSince(date)))
    }
}
