import SwiftData
import SwiftUI

struct LatestSleepLog: View {
    @EnvironmentObject private var model: BabyViewModel

    private let sleepService: SleepService

    @Query var items: [SleepAction]

    init(_ model: BabyViewModel, _ items: Int = 3) {
        self.sleepService = model.services.actionMapperService.getService(type: .sleep)
        let type = BabyActionType.sleep.rawValue
        let babyId = model.baby.persistentModelID

        let filter = #Predicate<SleepAction> { action in
            action.action == type &&
                action.end != nil &&
                action.deleted == false &&
                action.baby?.persistentModelID == babyId
        }

        var fetchDescriptor = FetchDescriptor<SleepAction>(predicate: filter, sortBy: [SortDescriptor<SleepAction>(\.end, order: .reverse)])
        fetchDescriptor.fetchLimit = items
        _items = Query(fetchDescriptor)
    }

    var body: some View {
        SleepLogView(sleepService: sleepService, items: items)
    }
}

struct SleepLogView: View {
    let sleepService: SleepService
    var items: [SleepAction]

    @State private var selectedSleep: SleepAction?

    private let gridColumns = [
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .leading),
    ]

    var body: some View {
        ForEach(items, id: \.self) { sleep in
            LazyVGrid(columns: gridColumns, spacing: 0) {
                Text(formatdate(date: sleep.start))
                    .onTapGesture {
                        self.selectedSleep = sleep
                    }
                HStack {
                    if sleep.night != nil && sleep.night == true {
                        Image(systemName: "moon")
                    }
                    Text(timeIntervalString(from: sleep.start, to: sleep.end ?? Date()))
                }
                .onTapGesture {
                    self.selectedSleep = sleep
                }
            }
            .padding(0)
            .font(.footnote)
        }

        if let selected = selectedSleep {
            let view = SleepView(sleep: selected, onChange: sleepService.update, onDelete: sleepService.delete)

            NavigationLink(destination: view, isActive: Binding<Bool>(
                get: { self.selectedSleep != nil },
                set: { if !$0 { self.selectedSleep = nil } }
            )) {
                EmptyView()
            }
            .isDetailLink(false)
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
