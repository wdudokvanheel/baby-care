import SwiftData
import SwiftUI

struct SleepLog: View {
    @Query()
    var items: [BabyAction]

    private let gridColumns = [
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .center),
        GridItem(.flexible(), alignment: .trailing)
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
                Text(timeIntervalString(from: sleep.start!, to: sleep.end!))
            }
            .padding(0)
            .font(.footnote)
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
