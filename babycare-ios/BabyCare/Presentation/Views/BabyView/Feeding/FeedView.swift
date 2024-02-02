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
            if let startDate = feeding.start {
                HStack(alignment: .bottom) {
                    Text("Start at")

                    if let endDate = feeding.end {
                        if !startDate.isSameDateIgnoringTime(as: endDate) {
                            Text("(\(startDate.formatDateAsRelativeString()))")
                                .foregroundStyle(Color.gray)
                                .font(.footnote)
                                .fontWeight(.light)
                        }
                    }

                    DatePicker("", selection: Binding(get: { startDate }, set: { newValue in
                        feeding.start = newValue
                        startDateUpdate()
                    }), displayedComponents: .hourAndMinute)
                }

                if let endDate = feeding.end {
                    HStack {
                        Text("End at")
                        if !startDate.isSameDateIgnoringTime(as: endDate) {
                            Text("(\(endDate.formatDateAsRelativeString()))")
                                .foregroundStyle(Color.gray)
                                .font(.footnote)
                                .fontWeight(.light)
                        }
                        DatePicker("", selection: Binding(get: { endDate }, set: { newValue in
                            feeding.end = newValue
                            endDateUpdate()
                        }),
                        in: startDate...,
                        displayedComponents: .hourAndMinute)
                    }
                    HStack {
                        Spacer()
                        Text("Total feed time of \(startDate.timeIntervalToString(to: endDate))")
                            .foregroundStyle(Color.white.opacity(0.75))
                            .font(.footnote)
                    }
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

    func startDateUpdate() {
        if let startDate = feeding.start, let endDate = feeding.end {
            let later = endDate.isTimeLaterThan(date: startDate)
            let sameDay = startDate.isSameDateIgnoringTime(as: endDate)

            if endDate < startDate, startDate.isSameDateIgnoringTime(as: endDate) {
                feeding.start = Calendar.current.date(byAdding: .day, value: -1, to: startDate)
            }
            else if !later, !sameDay {
                feeding.start = Calendar.current.date(byAdding: .day, value: 1, to: startDate)
            }
        }
        actionUpdate()
    }

    func endDateUpdate() {
        if let startDate = feeding.start, let endDate = feeding.end {
            let later = endDate.isTimeLaterThan(date: startDate)
            let sameDay = startDate.isSameDateIgnoringTime(as: endDate)

            if !later, !sameDay {
                feeding.start = Calendar.current.date(byAdding: .day, value: 1, to: startDate)
            }
        }
        actionUpdate()
    }

    func actionUpdate() {
        onChange(feeding)
    }

    func formatTime(date: Date?) -> String? {
        guard let date = date else { return nil }

        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
}
