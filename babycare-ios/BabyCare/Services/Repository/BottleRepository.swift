import Foundation
import os
import SwiftData
import SwiftUI

public class BottleRepository {
    func createQueryByDate(_ baby: Baby, _ date: Date) -> Query<BottleAction, [BottleAction]> {
        let babyId = baby.persistentModelID
        let type = BabyActionType.bottle.rawValue

        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!

        let filter = #Predicate<BottleAction> { action in
            action.action == type &&
                action.deleted == false &&
                action.baby?.persistentModelID == babyId &&
                action.start > start &&
                action.start < end
        }

        let fetchDescriptor = FetchDescriptor<BottleAction>(predicate: filter, sortBy: [SortDescriptor<BottleAction>(\.end, order: .reverse)])
        return Query(fetchDescriptor)
    }
}
