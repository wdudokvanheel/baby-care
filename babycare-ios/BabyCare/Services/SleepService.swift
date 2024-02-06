import Foundation
import os
import SwiftData
import SwiftUI

class SleepService {
    private let container: ModelContainer

    init(container: ModelContainer) {
        self.container = container
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
            let descriptor = FetchDescriptor<SleepAction>(predicate: #Predicate { sleep in
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

struct DaySleepDetailsModel: CustomDebugStringConvertible {
    var bedTime: Date = .init()
    var wakeTime: Date = .init()
    var naps: Int = 0
    var sleepTimeDay: Int = 0
    var sleepTimeNight: Int = 0

    var sleepTimeTotal: Int {
        return sleepTimeDay + sleepTimeNight
    }

    var debugDescription: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return """
        DaySleepDetailsModel:
            Bed Time: \(dateFormatter.string(from: bedTime))
            Wake Time: \(dateFormatter.string(from: wakeTime))
            Naps: \(naps)
            Total Sleep Time: \(sleepTimeTotal) minutes
            Day Sleep Time: \(sleepTimeDay) minutes
            Night Sleep Time: \(sleepTimeNight) minutes
        """
    }
}
