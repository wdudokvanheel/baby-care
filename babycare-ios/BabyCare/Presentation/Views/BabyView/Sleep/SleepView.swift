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
            if let startDate = sleep.start {
                HStack {
                    Text("Start at")
                    
                    if let endDate = sleep.end {
                        if !startDate.isSameDateIgnoringTime(as: endDate) {
                            Text("(\(startDate.formatDateAsRelativeString()))")
                                .foregroundStyle(Color.gray)
                                .font(.footnote)
                                .fontWeight(.light)
                        }
                    }
                    
                    DatePicker("", selection: Binding(get: { startDate }, set: { newValue in
                        sleep.start = newValue
                        startDateUpdate()
                    }), displayedComponents: .hourAndMinute)
                }

                if let endDate = sleep.end {
                    HStack {
                        Text("End at")
                        
                        if !startDate.isSameDateIgnoringTime(as: endDate) {
                            Text(endDate.formatDateAsRelativeString())
                                .foregroundStyle(Color.gray)
                                .font(.footnote)
                                .fontWeight(.light)
                        }
                        
                        DatePicker("", selection: Binding(get: { endDate }, set: { newValue in
                            sleep.end = newValue
                            endDateUpdate()
                        }),
                        in: startDate...,
                        displayedComponents: .hourAndMinute)
                    }
                    HStack {
                        Spacer()
                        Text("Total sleep time of \(startDate.timeIntervalToString(to: endDate))")
                            .foregroundStyle(Color.white.opacity(0.75))
                            .font(.footnote)
                    }
                }
            }
        }
        .padding(16)
        .navigationTitle("Sleep data")
    }

    func startDateUpdate() {
        if let startDate = sleep.start, let endDate = sleep.end {
            let later = endDate.isTimeLaterThan(date: startDate)
            let sameDay = startDate.isSameDateIgnoringTime(as: endDate)

            if endDate < startDate, startDate.isSameDateIgnoringTime(as: endDate) {
                sleep.start = Calendar.current.date(byAdding: .day, value: -1, to: startDate)
            }
            else if !later, !sameDay {
                sleep.start = Calendar.current.date(byAdding: .day, value: 1, to: startDate)
            }
        }
        actionUpdate()
    }

    func endDateUpdate() {
        if let startDate = sleep.start, let endDate = sleep.end {
            let later = endDate.isTimeLaterThan(date: startDate)
            let sameDay = startDate.isSameDateIgnoringTime(as: endDate)

            if !later, !sameDay {
                sleep.start = Calendar.current.date(byAdding: .day, value: 1, to: startDate)
            }
        }
        actionUpdate()
    }

    func actionUpdate() {
        onChange(sleep)
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
