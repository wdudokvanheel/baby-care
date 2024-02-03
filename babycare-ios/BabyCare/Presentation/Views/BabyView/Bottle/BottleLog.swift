import SwiftData
import SwiftUI

struct BottleLog: View {
    @EnvironmentObject
    private var model: BabyViewModel

    @Query()
    var items: [BottleAction]

    @State
    private var selectedBottle: BottleAction?

    private let gridColumns = [
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .leading),
    ]

    init(_ model: BabyViewModel) {
        let type = BabyActionType.bottle.rawValue
        let babyId = model.baby.persistentModelID

        let filter = #Predicate<BottleAction> { action in
            action.action ?? "" == type &&
                action.start != nil &&
                action.end != nil &&
                action.baby?.persistentModelID == babyId
        }

        var fetchDescriptor = FetchDescriptor<BottleAction>(predicate: filter, sortBy: [SortDescriptor<BottleAction>(\.end, order: .reverse)])
        fetchDescriptor.fetchLimit = 3
        _items = Query(fetchDescriptor)
    }

    var body: some View {
        ForEach(items, id: \.self) { bottle in
            LazyVGrid(columns: gridColumns, spacing: 0) {
                Text(bottle.start?.formatDateTimeAsRelativeString() ?? "")
                    .onTapGesture {
                        self.selectedBottle = bottle
                    }
                Text(timeIntervalString(from: bottle.start!, to: bottle.end!))
                    .onTapGesture {
                        self.selectedBottle = bottle
                    }
                if let quantity = bottle.quantity, quantity > 0 {
                    Text("\(quantity) ml")
                        .onTapGesture {
                            self.selectedBottle = bottle
                        }
                }
            }
            .padding(0)
            .font(.footnote)
        }

        if let selected = self.selectedBottle {
            let view = BottleView(bottle: selected, onChange: model.updateAction, onDelete: model.deleteAction)

            NavigationLink(destination: view, isActive: Binding<Bool>(
                get: { self.selectedBottle != nil },
                set: { if !$0 { self.selectedBottle = nil } }
            )) {
                EmptyView()
            }
        }
    }

    func timeIntervalString(from startDate: Date, to endDate: Date) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]

        let interval = endDate.timeIntervalSince(startDate)
        return formatter.string(from: TimeInterval(interval)) ?? "N/A"
    }
}
