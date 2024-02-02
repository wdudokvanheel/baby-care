import Combine
import SwiftUI

struct BottleView: View {
    @State
    private var showingStartPicker = false
    @State
    private var showingEndPicker = false
    @State
    var bottle: BottleAction
    var onChange: (BottleAction) -> Void
    @State
    var quantity: String = "0"

    var quantityInt: Int64? {
        if quantity.isEmpty {
            return nil
        }
        return Int64(quantity)
    }

    init(_ bottle: BottleAction, _ onChange: @escaping (BottleAction) -> Void) {
        self.quantity = String(bottle.quantity ?? 0)
        self.bottle = bottle
        self.onChange = onChange
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let startDate = bottle.start {
                HStack {
                    Text("Start at")

                    if let endDate = bottle.end {
                        if !startDate.isSameDateIgnoringTime(as: endDate) {
                            Text("(\(startDate.formatDateAsRelativeString()))")
                                .foregroundStyle(Color.gray)
                                .font(.footnote)
                                .fontWeight(.light)
                        }
                    }

                    DatePicker("", selection: Binding(get: { startDate }, set: { newValue in
                        bottle.start = newValue
                        startDateUpdate()
                    }), displayedComponents: .hourAndMinute)
                }

                if let endDate = bottle.end {
                    HStack {
                        Text("End at")

                        if !startDate.isSameDateIgnoringTime(as: endDate) {
                            Text("(\(endDate.formatDateAsRelativeString()))")
                                .foregroundStyle(Color.gray)
                                .font(.footnote)
                                .fontWeight(.light)
                        }

                        DatePicker("", selection: Binding(get: { endDate }, set: { newValue in
                            bottle.end = newValue
                            endDateUpdate()
                        }),
                        in: startDate...,
                        displayedComponents: .hourAndMinute)
                    }
                    HStack {
                        Spacer()
                        Text("Total bottle feeding time of \(startDate.timeIntervalToString(to: endDate))")
                            .foregroundStyle(Color.white.opacity(0.75))
                            .font(.footnote)
                    }
                }
            }

            HStack {
                Text("Milliliter")
                TextField("Ml", text: Binding(get: { self.quantity }, set: { val in
                    if self.quantity == val {
                        return
                    }
                    self.quantity = val
                    bottle.quantity = self.quantityInt
                    actionUpdate()
                }))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
            }
            Spacer()
        }
        .padding(16)
        .navigationTitle("Bottle bottle data")
    }

    func startDateUpdate() {
        if let startDate = bottle.start, let endDate = bottle.end {
            let later = endDate.isTimeLaterThan(date: startDate)
            let sameDay = startDate.isSameDateIgnoringTime(as: endDate)

            if endDate < startDate, startDate.isSameDateIgnoringTime(as: endDate) {
                bottle.start = Calendar.current.date(byAdding: .day, value: -1, to: startDate)
            }
            else if !later, !sameDay {
                bottle.start = Calendar.current.date(byAdding: .day, value: 1, to: startDate)
            }
        }
        actionUpdate()
    }

    func endDateUpdate() {
        if let startDate = bottle.start, let endDate = bottle.end {
            let later = endDate.isTimeLaterThan(date: startDate)
            let sameDay = startDate.isSameDateIgnoringTime(as: endDate)

            if !later, !sameDay {
                bottle.start = Calendar.current.date(byAdding: .day, value: 1, to: startDate)
            }
        }
        actionUpdate()
    }

    func actionUpdate() {
        onChange(bottle)
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
