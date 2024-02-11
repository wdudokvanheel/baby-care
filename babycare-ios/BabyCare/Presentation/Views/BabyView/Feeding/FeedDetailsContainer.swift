import Foundation
import SwiftData
import SwiftUI

struct FeedDetailsContainer<Content: View>: View {
    private let date: Date
    private let baby: Baby
    private let content: (DailyFeedDetails) -> Content

    @Query()
    var query: [DailyFeedDetails]

    var details: DailyFeedDetails? {
        if query.count > 0 {
            return query[0]
        }
        return nil
    }

    init(_ date: Date, _ baby: Baby, @ViewBuilder _ content: @escaping (DailyFeedDetails) -> Content) {
        self.date = date
        self.baby = baby
        self.content = content
        
        _query = FeedService.createQueryDetailsByDate(date, baby)
    }

    var body: some View {
        if let details = details {
            content(details)
        }
    }
}
