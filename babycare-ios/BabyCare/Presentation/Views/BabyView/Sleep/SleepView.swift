import SwiftUI

struct SleepView: View {
    @State
    private var showingStartPicker = false
    @State
    private var showingEndPicker = false
    @State
    var sleep: BabyAction
    var onChange: (BabyAction) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Start at")
                if let startDate = sleep.start {
                    DatePicker("", selection: Binding(get: { startDate }, set: { newValue in
                        sleep.start = newValue
                        dateChanged()
                    }), displayedComponents: .hourAndMinute)
                }
            }

            HStack {
                Text("End at")
                if let endDate = sleep.end {
                    DatePicker("", selection: Binding(get: { endDate }, set: { newValue in
                        sleep.end = newValue
                        dateChanged()
                    }), displayedComponents: .hourAndMinute)
                }
            }
        }
        .padding(16)
        .navigationTitle("Sleep data")
    }

    func dateChanged() {
        print("Updating action")
        onChange(sleep)
    }

    func formatTime(date: Date?) -> String? {
        guard let date = date else { return nil }

        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short // You can change this to .medium, .long, or .full
        formatter.locale = Locale.current // Ensures user's locale format is used
        return formatter.string(from: date)
    }
}
