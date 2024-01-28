import SwiftData
import SwiftUI

struct FeedLog: View {
    @Query()
    var items: [FeedAction]

    private let gridColumns = [
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .center),
        GridItem(.flexible(), alignment: .trailing)
    ]

    init(_ model: BabyViewModel) {
        let type = BabyActionType.feed.rawValue
        let babyId = model.baby.persistentModelID

        let filter = #Predicate<FeedAction> { action in
            action.action ?? "" == type &&
                action.start != nil &&
                action.end != nil &&
                action.baby?.persistentModelID == babyId
        }

        var fetchDescriptor = FetchDescriptor<FeedAction>(predicate: filter, sortBy: [SortDescriptor<FeedAction>(\.end, order: .reverse)])
        fetchDescriptor.fetchLimit = 3
        _items = Query(fetchDescriptor)
    }

    var body: some View {
        ForEach(items, id: \.self) { feeding in
            LazyVGrid(columns: gridColumns, spacing: 0) {

                Text(formatdate(date: feeding.start!))
                HStack {
                    Image(systemName: getSideIcon(feeding))
                    Text(timeIntervalString(from: feeding.start!, to: feeding.end!))
                }
            }
            .padding(0)
            .font(.footnote)
        }
    }

    func getSideIcon(_ feeding: FeedAction) -> String {
        switch feeding.feedSide {
            case .left:
                "l.circle.fill"
            case .right:
                "r.circle.fill"
            case .none:
                "questionmark.circle.fill"
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
