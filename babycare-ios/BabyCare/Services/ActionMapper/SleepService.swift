import SwiftData
import SwiftUI

class SleepService: ActionService {
    typealias ActionType = SleepAction

    private let container: ModelContainer
    private let actionService: BabyActionService

    init(services: ServiceContainer) {
        self.container = services.container
        self.actionService = services.actionService
    }

    func start(_ baby: Baby) -> any Action {
        let action: SleepAction = actionService.createAction(baby: baby, type: .sleep)

        let hour = Calendar.current.component(.hour, from: Date())
        action.night = hour >= BabyCareApp.nightStartHour || hour < BabyCareApp.nightEndHour

        actionService.persistAction(action)
        return action
    }

    func stop(_ action: any Action) {
        actionService.endAction(action)
        onActionUpdate(action)
    }

    func update(_ action: any Action) {
        action.syncRequired = true
        actionService.persistAction(action)
        onActionUpdate(action)
    }

    func onActionUpdate(_ action: any Action) {
        print("Update details for sleep action #\(action.remoteId ?? 0)")

        if let baby = action.baby {
            Task {
                await updateSleepDetails(action.start, baby)
                await updateSleepDetails(Calendar.current.date(byAdding: .day, value: 1, to: action.start)!, baby)
            }
        }
    }

    func createDetailsIfUnavailable(_ date: Date, baby: Baby) {
        Task {
            let date = Calendar.current.startOfDay(for: date)

            if await getSleepDetailsStorage(date, baby) != nil {
                return
            }
            let model = DailySleepDetails(date: date)

            await MainActor.run {
                model.baby = baby
            }
            await updateSleepModel(model)

            let updateModel = model
            await MainActor.run {
                container.mainContext.insert(updateModel)
            }
        }
    }

    func delete(_ action: any Action) {
        actionService.deleteAction(action)
        onActionUpdate(action)
    }

    func createQueryByDate(_ baby: Baby, _ date: Date) -> Query<SleepAction, [SleepAction]> {
        let babyId = baby.persistentModelID
        let type = BabyActionType.sleep.rawValue

        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!

        let filter = #Predicate<SleepAction> { action in
            action.end != nil &&
                action.action == type &&
                action.deleted == false &&
                action.baby?.persistentModelID == babyId &&
                action.start > start &&
                action.start < end
        }

        let fetchDescriptor = FetchDescriptor<SleepAction>(predicate: filter, sortBy: [SortDescriptor<SleepAction>(\.end, order: .reverse)])
        return Query(fetchDescriptor)
    }

    // TODO: Separate from sleepservice to sleepdetailsservice
    public func updateSleepDetails(_ date: Date, _ baby: Baby) async {
        let date = Calendar.current.startOfDay(for: date)

        var insert = false
        var model: DailySleepDetails

        if let details = await getSleepDetailsStorage(date, baby) {
            model = details
        } else {
            insert = true
            model = DailySleepDetails(date: date)
            let m = model
            await MainActor.run {
                m.baby = baby
            }
        }

        await updateSleepModel(model)

        if insert {
            let model = model
            await MainActor.run {
                container.mainContext.insert(model)
            }
        }
    }

    private func updateSleepModel(_ model: DailySleepDetails) async {
        guard let baby = model.baby else {
            return
        }
        let date = model.date

        let actions = await getActionsForDate(date, baby)
        let night = getNightActions(date, actions)

        await MainActor.run {
//            print("Updating details for \(date)")
//
//            for x in actions {
//                print("\t#\(x.remoteId ?? 0) \(x.start.formatted()) \(x.duration) Night: \(x.night)")
//            }

            if !night.isEmpty {
                if let first = night.first {
                    model.bedTime = first.start
                }
                if let last = night.last, let end = last.end {
                    model.wakeTime = end
                }
            }
            model.naps = Int16(getTotalNaps(date, actions))

            model.sleepTimeDay = Int32(actions.filter { $0.start.isSameDateIgnoringTime(as: date) && $0.night == false }.reduce(0) { $0 + $1.duration })
            model.sleepTimeNight = Int32(night.reduce(0) { $0 + $1.duration })

//            let total = actions.map { $0.duration }.reduce(0) { $0 + $1 }
//            print("actions: \(actions.count) day: \(model.sleepTimeDayInt) night:  \(model.sleepTimeNightInt) total: \(total)")
        }
    }

    public func getSleepDetailsStorage(_ date: Date, _ baby: Baby) async -> DailySleepDetails? {
        await MainActor.run {
            let date = Calendar.current.startOfDay(for: date)
            let babyId = baby.persistentModelID

            let descriptor = FetchDescriptor<DailySleepDetails>(predicate: #Predicate { day in
                day.baby?.persistentModelID == babyId &&
                    day.date == date
            })

            do {
                let result = try container.mainContext.fetch(descriptor)
                if result.count > 0 {
                    return result[0]
                }
            } catch {
                print("Error \(error)")
            }

            return nil
        }
    }

    private func getTotalNaps(_ date: Date, _ actions: [SleepAction]) -> Int {
        return actions.filter { $0.start.isSameDateIgnoringTime(as: date) && $0.night == false }.count
    }

    private func getNightActions(_ date: Date, _ actions: [SleepAction]) -> [SleepAction] {
        let today = actions.filter { $0.start.isSameDateIgnoringTime(as: date) }
        let yesterday = actions.filter { !$0.start.isSameDateIgnoringTime(as: date) }

        var night: [SleepAction] = []

        // TODO: Omit early day night results as extra precaution
        // Check if yesterday ended with a night sleep
        if yesterday.last?.night == true {
            // Get all items from last night
            if let indexReverse: Int = yesterday.reversed().firstIndex(where: { $0.night == nil || $0.night! == false }) {
                let indexOriginal = yesterday.endIndex - indexReverse
                let splice = Array(yesterday.suffix(from: indexOriginal))
                night.append(contentsOf: splice)
            } else {
                night.append(contentsOf: yesterday)
            }
        }

        if today.first?.night == true {
            if let index = today.firstIndex(where: { $0.night == nil || $0.night! == false }) {
                let splice = Array(today.prefix(index))
                night.append(contentsOf: splice)
            } else {
                night.append(contentsOf: today)
            }
        }

        return night
    }

    private func getActionsForDate(_ date: Date, _ baby: Baby) async -> [SleepAction] {
        let startOfDay = Calendar.current.startOfDay(for: date)

        // Get actions from day before as well
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: startOfDay)!
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!

        return await MainActor.run {
            let babyId = baby.persistentModelID
            let descriptor = FetchDescriptor<SleepAction>(predicate: #Predicate { sleep in
                sleep.baby?.persistentModelID == babyId &&
                    sleep.start >= startDate &&
                    sleep.start <= endDate &&
                    sleep.deleted != true
            }, sortBy: [SortDescriptor<SleepAction>(\.start)])
            do {
                let result = try container.mainContext.fetch(descriptor)
                if result.count > 0 {
                    return result
                }
            } catch {
                print("Error \(error)")
            }

            return []
        }
    }
}
