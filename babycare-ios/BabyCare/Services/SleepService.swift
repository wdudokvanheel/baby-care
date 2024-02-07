import SwiftData
import SwiftUI

class SleepService: ObservableObject {
    @Published
    public var detailsToday: DaySleepDetailsModel

    private let baby: Baby
    private let container: ModelContainer
    private var timer: Timer?

    init(container: ModelContainer, baby: Baby) {
        self.container = container
        self.baby = baby
        detailsToday = DaySleepDetailsModel()

        updateTodayDetails()

        NotificationCenter.default.addObserver(self, selector: #selector(updateTodayDetails), name: Notification.Name("update_sleep"), object: nil)

        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.updateTodayDetails()
        }
    }

    @objc func updateTodayDetails() {
        Task {
            let details = await getSleepDetails(Date())
            DispatchQueue.main.async {
                self.detailsToday = details
            }
        }
    }

    public func getSleepDetails(_ date: Date) async -> DaySleepDetailsModel {
        var model = DaySleepDetailsModel()
        let actions = await getActionsForDate(date)

        let night = getNightActions(date, actions)

        if !night.isEmpty {
            if let first = night.first {
                model.bedTime = first.start
            }
            if let last = night.last, let end = last.end {
                model.wakeTime = end
            }
        }
        model.naps = getTotalNaps(date, actions)

        model.sleepTimeDay = Int(actions.filter { $0.start.isSameDateIgnoringTime(as: date) && $0.night == false }.reduce(0) { $0 + $1.duration })
        model.sleepTimeNight = Int(night.reduce(0) { $0 + $1.duration })
        return model
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

    private func getActionsForDate(_ date: Date) async -> [SleepAction] {
        let startOfDay = Calendar.current.startOfDay(for: date)

        // Get actions from day before as well
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: startOfDay)!
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!

        return await MainActor.run {
            let babyId = self.baby.persistentModelID
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

    deinit {
        timer?.invalidate()
    }
}

struct DaySleepDetailsModel: CustomDebugStringConvertible {
    var bedTime: Date?
    var wakeTime: Date?
    var naps: Int = 0
    var sleepTimeDay: Int = 0
    var sleepTimeNight: Int = 0

    var sleepTimeTotal: Int {
        return sleepTimeDay + sleepTimeNight
    }

    var debugDescription: String {
        let bedTimeStr = bedTime?.formatted() ?? "nil"
        let wakeTimeStr = wakeTime?.formatted() ?? "nil"
        return """
        DaySleepDetailsModel:
            Bed Time: \(bedTimeStr)
            Wake Time: \(wakeTimeStr)
            Naps: \(naps)
            Sleep Time Day: \(sleepTimeDay) minutes
            Sleep Time Night: \(sleepTimeNight) minutes
            Total Sleep Time: \(sleepTimeTotal) minutes
        """
    }
}
