import SwiftData
import SwiftUI

public class FeedingCareViewModel: ObservableObject {
    @Published
    var baby: Baby

    var services: ServiceContainer

    init(baby: Baby, services: ServiceContainer) {
        self.baby = baby
        self.services = services
    }

    func buttonStartFeeding() {
        _ = services.feedService.start(baby)
    }

    func buttonStopFeeding(_ action: FeedAction) {
        services.feedService.stop(action)
    }

    func updateFeedActionStart(_ action: FeedAction, _ start: Date) {
        action.start = start

        let endDate = Date()
        let startDate = action.start
        let later = endDate.isTimeLaterThan(date: startDate)
        let sameDay = startDate.isSameDateIgnoringTime(as: endDate)

        if endDate < startDate, startDate.isSameDateIgnoringTime(as: endDate) {
            action.start = Calendar.current.date(byAdding: .day, value: -1, to: startDate)!
        }
        else if !later, !sameDay {
            action.start = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
        }

        services.feedService.update(action)
    }

    func activeFeedQuery() -> Query<FeedAction, [FeedAction]> {
        let type = BabyActionType.feed.rawValue
        let babyId = baby.persistentModelID
        let filter = #Predicate<FeedAction> { action in
            action.action ?? "" == type &&
                action.end == nil &&
                action.baby?.persistentModelID == babyId
        }
        var fetchDescriptor = FetchDescriptor<FeedAction>(predicate: filter)
        fetchDescriptor.fetchLimit = 1
        return Query(fetchDescriptor)
    }

    static func feedDetailsQuery(_ date: Date, _ baby: Baby) -> Query<DailyFeedDetails, [DailyFeedDetails]> {
        let date = Calendar.current.startOfDay(for: date)
        let babyId = baby.persistentModelID

        let filter = #Predicate<DailyFeedDetails> { details in
            details.baby?.persistentModelID == babyId &&
                details.date == date
        }

        var fetchDescriptor = FetchDescriptor<DailyFeedDetails>(predicate: filter)
        fetchDescriptor.fetchLimit = 1
        return Query(fetchDescriptor)
    }

    static func feedDetailsPastDays(_ date: Date, _ baby: Baby, _ days: Int) -> Query<DailyFeedDetails, [DailyFeedDetails]> {
        let date = Calendar.current.startOfDay(for: date)
        let startDate = Calendar.current.date(byAdding: .day, value: -days + 1, to: date)!

        let babyId = baby.persistentModelID

        let filter = #Predicate<DailyFeedDetails> { details in
            details.baby?.persistentModelID == babyId &&
                details.date >= startDate &&
                details.date <= date
        }

        var fetchDescriptor = FetchDescriptor<DailyFeedDetails>(predicate: filter, sortBy: [SortDescriptor<DailyFeedDetails>(\.date)])
        fetchDescriptor.fetchLimit = days
        return Query(fetchDescriptor)
    }

    static func feedDetailsPastWeekQuery(_ date: Date, _ baby: Baby) -> Query<DailyFeedDetails, [DailyFeedDetails]> {
        return feedDetailsPastDays(date, baby, 7)
    }
    
    static func feedDetailsPastMonthQuery(_ date: Date, _ baby: Baby) -> Query<DailyFeedDetails, [DailyFeedDetails]> {
        return feedDetailsPastDays(date, baby, 31)
    }
}
