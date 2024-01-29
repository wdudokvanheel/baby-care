import SwiftData
import SwiftUI

struct FeedLog: View {
    @EnvironmentObject
    private var model: BabyViewModel

    @Query()
    var items: [FeedAction]

    @State
    private var selectedFeed: FeedAction?

    private let gridColumns = [
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .leading),
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
                    .onTapGesture {
                        self.selectedFeed = feeding
                    }
                HStack {
                    Image(systemName: getSideIcon(feeding))
                    Text(timeIntervalString(from: feeding.start!, to: feeding.end!))
                }
                .onTapGesture {
                    self.selectedFeed = feeding
                }
            }
            .padding(0)
            .font(.footnote)
        }

        if let selected = self.selectedFeed {
            let view = FeedView(feeding: selected, onChange: { feed in
                self.model.updateAction(feed)
            })

            NavigationLink(destination: view, isActive: Binding<Bool>(
                get: { self.selectedFeed != nil },
                set: { if !$0 { self.selectedFeed = nil } }
            )) {
                EmptyView()
            }
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
