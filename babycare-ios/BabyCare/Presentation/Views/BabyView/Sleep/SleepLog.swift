import SwiftData
import SwiftUI

struct SleepLog: View {
    @EnvironmentObject
    private var model: BabyViewModel

    @Query()
    var items: [BabyAction]

    @State
    private var selectedSleep: BabyAction?

    private let gridColumns = [
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .leading),
    ]

    init(_ model: BabyViewModel) {
        let type = BabyActionType.sleep.rawValue
        let babyId = model.baby.persistentModelID

        let filter = #Predicate<BabyAction> { action in
            action.action ?? "" == type &&
                action.start != nil &&
                action.end != nil &&
                action.baby?.persistentModelID == babyId
        }

        var fetchDescriptor = FetchDescriptor<BabyAction>(predicate: filter, sortBy: [SortDescriptor<BabyAction>(\.end, order: .reverse)])
        fetchDescriptor.fetchLimit = 3
        _items = Query(fetchDescriptor)
    }

    var body: some View {
        ForEach(items, id: \.self) { sleep in

            LazyVGrid(columns: gridColumns, spacing: 0) {
                Text(formatdate(date: sleep.start!))
                    .onTapGesture {
                        self.selectedSleep = sleep
                    }
                Text(timeIntervalString(from: sleep.start!, to: sleep.end!))
                    .onTapGesture {
                        self.selectedSleep = sleep
                    }
            }
            .padding(0)
            .font(.footnote)
        }

        if let selected = self.selectedSleep {
            let view = SleepView(sleep: selected, onChange: { sleep in
                self.model.updateAction(sleep)
            }, onDelete: { sleep in
                self.model.deleteAction(sleep)
            })

            NavigationLink(destination: view, isActive: Binding<Bool>(
                get: { self.selectedSleep != nil },
                set: { if !$0 { self.selectedSleep = nil } }
            )) {
                EmptyView()
            }
        }
    }

    func formatdate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true

        return dateFormatter.string(from: date)
    }

    func timeIntervalString(from startDate: Date, to endDate: Date) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]

        let interval = endDate.timeIntervalSince(startDate)
        return formatter.string(from: TimeInterval(interval)) ?? "N/A"
    }
}
