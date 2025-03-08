import SwiftData
import SwiftUI

public class SleepCareViewModel: ObservableObject {
    @Published var baby: Baby
    @Published var date: Date

    var services: ServiceContainer

    init(baby: Baby, services: ServiceContainer) {
        self.date = Date()
        self.baby = baby
        self.services = services
    }

    func buttonStartSleep() {
        _ = services.sleepService.start(baby)
    }

    func buttonStopSleep(_ action: SleepAction) {
        services.sleepService.stop(action)
    }

    func updateSleepActionIsNight(_ action: SleepAction, _ value: Bool) {
        action.night = value
        services.sleepService.update(action)
    }

    func updateSleepActionStart(_ action: SleepAction, _ start: Date) {
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

        services.sleepService.update(action)
    }

    func sleepActionsSelectedDate() -> Query<SleepAction, [SleepAction]> {
        let type = BabyActionType.sleep.rawValue
        let babyId = baby.persistentModelID
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: startOfDay)!

        let filter = #Predicate<SleepAction> { action in
            action.action ?? "" == type &&
                action.start >= yesterday &&
                action.start < endOfDay &&
                action.baby?.persistentModelID == babyId
        }

        var fetchDescriptor = FetchDescriptor<SleepAction>(predicate: filter, sortBy: [SortDescriptor(\SleepAction.start)])
        return Query(fetchDescriptor)
    }

    func activeSleepQuery() -> Query<SleepAction, [SleepAction]> {
        let type = BabyActionType.sleep.rawValue
        let babyId = baby.persistentModelID
        let filter = #Predicate<SleepAction> { action in
            action.action ?? "" == type &&
                action.end == nil &&
                action.baby?.persistentModelID == babyId
        }
        var fetchDescriptor = FetchDescriptor<SleepAction>(predicate: filter)
        fetchDescriptor.fetchLimit = 1
        return Query(fetchDescriptor)
    }

    func updateDailyDetails(_ date: Date, _ baby: Baby) {
        Task {
            await services.sleepService.updateSleepDetails(date, baby)
        }
    }

    static func sleepDetailsQuery(_ date: Date, _ baby: Baby) -> Query<DailySleepDetails, [DailySleepDetails]> {
        let date = Calendar.current.startOfDay(for: date)
        let babyId = baby.persistentModelID

        let filter = #Predicate<DailySleepDetails> { details in
            details.baby?.persistentModelID == babyId &&
                details.date == date
        }

        var fetchDescriptor = FetchDescriptor<DailySleepDetails>(predicate: filter)
        fetchDescriptor.fetchLimit = 1
        return Query(fetchDescriptor)
    }

    static func sleepDetailsPastDaysQuery(_ date: Date, _ baby: Baby, _ days: Int) -> Query<DailySleepDetails, [DailySleepDetails]> {
        let date = Calendar.current.startOfDay(for: date)
        let startDate = Calendar.current.date(byAdding: .day, value: -days + 1, to: date)!

        let babyId = baby.persistentModelID

        let filter = #Predicate<DailySleepDetails> { details in
            details.baby?.persistentModelID == babyId &&
                details.date >= startDate &&
                details.date <= date
        }

        var fetchDescriptor = FetchDescriptor<DailySleepDetails>(predicate: filter, sortBy: [SortDescriptor<DailySleepDetails>(\.date)])
        fetchDescriptor.fetchLimit = days
        return Query(fetchDescriptor)
    }

    static func sleepDetailsPastMonthQuery(_ date: Date, _ baby: Baby) -> Query<DailySleepDetails, [DailySleepDetails]> {
        return sleepDetailsPastDaysQuery(date, baby, 31)
    }

    static func sleepDetailsPastWeekQuery(_ date: Date, _ baby: Baby) -> Query<DailySleepDetails, [DailySleepDetails]> {
        return sleepDetailsPastDaysQuery(date, baby, 7)
    }
}
