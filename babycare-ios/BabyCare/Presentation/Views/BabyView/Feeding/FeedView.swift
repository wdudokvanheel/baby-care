import SwiftUI

struct FeedView: View {
    @State
    private var showingStartPicker = false
    @State
    private var showingEndPicker = false
    @State
    var feeding: FeedAction
    var onChange: (FeedAction) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Start at")
                if let startDate = feeding.start {
                    DatePicker("", selection: Binding(get: { startDate }, set: { newValue in
                        feeding.start = newValue
                        actionUpdate()
                    }), displayedComponents: .hourAndMinute)
                }
            }

            HStack {
                Text("End at")
                if let endDate = feeding.end {
                    DatePicker("", selection: Binding(get: { endDate }, set: { newValue in
                        feeding.end = newValue
                        actionUpdate()
                    }), displayedComponents: .hourAndMinute)
                }
            }

            HStack {
                Text("Feed side")
                Picker("", selection: $feeding.feedSide) {
                    ForEach(FeedSide.allCases, id: \.self) { side in
                        Text(side.rawValue.capitalized).tag(side as FeedSide?)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: feeding.feedSide) {
                    actionUpdate()
                }
            }
        }
        .padding(16)
        .navigationTitle("Breast feeding data")
    }

    func actionUpdate() {
        onChange(feeding)
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
