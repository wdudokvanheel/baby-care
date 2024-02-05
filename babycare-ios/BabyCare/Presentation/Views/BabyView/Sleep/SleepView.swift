import SwiftUI

struct SleepView: View {
    @Environment(\.presentationMode)
    var presentationMode

    @State
    private var showingStartPicker = false
    @State
    private var showingEndPicker = false
    @State
    private var showingDeleteConfirmation = false

    @State
    var sleep: BabyAction
    var onChange: (BabyAction) -> Void
    var onDelete: (BabyAction) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Start at")

                if let endDate = sleep.end {
                    if !sleep.start.isSameDateIgnoringTime(as: endDate) {
                        Text("(\(sleep.start.formatDateAsRelativeString()))")
                            .foregroundStyle(Color.gray)
                            .font(.footnote)
                            .fontWeight(.light)
                    }
                }

                DatePicker("", selection: Binding(get: { sleep.start }, set: { newValue in
                    sleep.start = newValue
                    startDateUpdate()
                }), displayedComponents: .hourAndMinute)
            }

            if let endDate = sleep.end {
                HStack {
                    Text("End at")

                    if !sleep.start.isSameDateIgnoringTime(as: endDate) {
                        Text(endDate.formatDateAsRelativeString())
                            .foregroundStyle(Color.gray)
                            .font(.footnote)
                            .fontWeight(.light)
                    }

                    DatePicker("", selection: Binding(get: { endDate }, set: { newValue in
                        sleep.end = newValue
                        endDateUpdate()
                    }),
                    in: sleep.start...,
                    displayedComponents: .hourAndMinute)
                }
                HStack {
                    Spacer()
                    Text("Total sleep time of \(sleep.start.timeIntervalToString(to: endDate))")
                        .foregroundStyle(Color.white.opacity(0.75))
                        .font(.footnote)
                }
            }
        }
        Spacer()

        DeleteButton {
            onDelete(sleep)
            presentationMode.wrappedValue.dismiss()
        }
        .padding(16)
        .navigationTitle("Sleep data")
    }

    func startDateUpdate() {
        let startDate = sleep.start
        if let endDate = sleep.end {
            let later = endDate.isTimeLaterThan(date: startDate)
            let sameDay = startDate.isSameDateIgnoringTime(as: endDate)

            if endDate < startDate, startDate.isSameDateIgnoringTime(as: endDate) {
                sleep.start = Calendar.current.date(byAdding: .day, value: -1, to: startDate)!
            }
            else if !later, !sameDay {
                sleep.start = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
            }
        }
        actionUpdate()
    }

    func endDateUpdate() {
        let startDate = sleep.start

        if let endDate = sleep.end {
            let later = endDate.isTimeLaterThan(date: startDate)
            let sameDay = startDate.isSameDateIgnoringTime(as: endDate)

            if !later, !sameDay {
                sleep.start = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
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
