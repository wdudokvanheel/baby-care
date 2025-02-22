import SwiftUI
import SwiftData

public class SleepCareViewModel: ObservableObject {
    @Published
    var baby: Baby

    var services: ServiceContainer

    init(baby: Baby, services: ServiceContainer) {
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

    func createActiveSleepQuery() -> Query<SleepAction, [SleepAction]> {
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
}
