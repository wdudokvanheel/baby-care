import Foundation
import os
import SwiftData
import SwiftUI

public class FeedRepository {
    func createQueryByDate(_ baby: Baby, _ date: Date) -> Query<FeedAction, [FeedAction]> {
        let babyId = baby.persistentModelID
        let type = BabyActionType.feed.rawValue

        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!

        let filter = #Predicate<FeedAction> { action in
            action.action == type &&
                action.deleted == false &&
                action.baby?.persistentModelID == babyId &&
                action.start > start &&
                action.start < end
        }

        let fetchDescriptor = FetchDescriptor<FeedAction>(predicate: filter, sortBy: [SortDescriptor<FeedAction>(\.end, order: .reverse)])
        return Query(fetchDescriptor)
    }
}
