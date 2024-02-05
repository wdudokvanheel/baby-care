import Combine
import SwiftUI

struct BottleView: View {
    @Environment(\.presentationMode)
    private var presentationMode

    @State
    private var showingStartPicker = false
    @State
    private var showingEndPicker = false
    @State
    private var quantity: String = "0"
    @State
    private var showingDeleteConfirmation = false

    @State
    var bottle: BottleAction
    var onChange: (BottleAction) -> Void
    var onDelete: (BottleAction) -> Void

    var quantityInt: Int64? {
        if quantity.isEmpty {
            return nil
        }
        return Int64(quantity)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Start at")

                if let endDate = bottle.end {
                    if !bottle.start.isSameDateIgnoringTime(as: endDate) {
                        Text("(\(bottle.start.formatDateAsRelativeString()))")
                            .foregroundStyle(Color.gray)
                            .font(.footnote)
                            .fontWeight(.light)
                    }
                }

                DatePicker("", selection: Binding(get: { bottle.start }, set: { newValue in
                    bottle.start = newValue
                    startDateUpdate()
                }), displayedComponents: .hourAndMinute)
            }

            if let endDate = bottle.end {
                HStack {
                    Text("End at")

                    if !bottle.start.isSameDateIgnoringTime(as: endDate) {
                        Text("(\(endDate.formatDateAsRelativeString()))")
                            .foregroundStyle(Color.gray)
                            .font(.footnote)
                            .fontWeight(.light)
                    }

                    DatePicker("", selection: Binding(get: { endDate }, set: { newValue in
                        bottle.end = newValue
                        endDateUpdate()
                    }),
                    in: bottle.start...,
                    displayedComponents: .hourAndMinute)
                }
                HStack {
                    Spacer()
                    Text("Total bottle feeding time of \(bottle.start.timeIntervalToString(to: endDate))")
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

        DeleteButton {
            onDelete(bottle)
            presentationMode.wrappedValue.dismiss()
        }
        .onAppear {
            self.quantity = String(bottle.quantity ?? 0)
        }
        .padding(16)
        .navigationTitle("Bottle bottle data")
    }

    func startDateUpdate() {
        let startDate = bottle.start
        if let endDate = bottle.end {
            let later = endDate.isTimeLaterThan(date: startDate)
            let sameDay = startDate.isSameDateIgnoringTime(as: endDate)

            if endDate < startDate, startDate.isSameDateIgnoringTime(as: endDate) {
                bottle.start = Calendar.current.date(byAdding: .day, value: -1, to: startDate)!
            }
            else if !later, !sameDay {
                bottle.start = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
            }
        }
        actionUpdate()
    }

    func endDateUpdate() {
        let startDate = bottle.start

        if let endDate = bottle.end {
            let later = endDate.isTimeLaterThan(date: startDate)
            let sameDay = startDate.isSameDateIgnoringTime(as: endDate)

            if !later, !sameDay {
                bottle.start = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
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
