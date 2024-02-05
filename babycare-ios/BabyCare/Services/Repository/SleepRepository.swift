import Foundation
import os
import SwiftData
import SwiftUI

public class SleepRepository {
    func createQueryByDate(_ baby: Baby, _ date: Date) -> Query<BabyAction, [BabyAction]> {
        let babyId = baby.persistentModelID
        let type = BabyActionType.sleep.rawValue

        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!

        let filter = #Predicate<BabyAction> { action in
            action.action == type &&
                action.deleted == false &&
                action.baby?.persistentModelID == babyId &&
                action.start > start &&
                action.start < end
        }

        let fetchDescriptor = FetchDescriptor<BabyAction>(predicate: filter, sortBy: [SortDescriptor<BabyAction>(\.end, order: .reverse)])
        return Query(fetchDescriptor)
    }
}
