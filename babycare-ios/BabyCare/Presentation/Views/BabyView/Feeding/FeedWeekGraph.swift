import Charts
import Foundation
import os
import SwiftData
import SwiftUI

struct FeedWeekGraph: View {
    @Query
    var query: [DailyFeedDetails]

    let feedService: FeedService
    let date: Date
    let baby: Baby

    init(_ date: Date, _ baby: Baby, feedService: FeedService) {
        self.date = date
        self.baby = baby
        self.feedService = feedService

        let date = Calendar.current.startOfDay(for: date)
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: date)!

        let babyId = baby.persistentModelID

        let filter = #Predicate<DailyFeedDetails> { details in
            details.baby?.persistentModelID == babyId &&
                details.date >= startDate &&
                details.date <= date
        }

        var fetchDescriptor = FetchDescriptor<DailyFeedDetails>(predicate: filter, sortBy: [SortDescriptor<DailyFeedDetails>(\.date)])
        fetchDescriptor.fetchLimit = 7
        _query = Query(fetchDescriptor)
    }

    var body: some View {
        VStack {
            Chart(query, id: \.persistentModelID) { day in
                BarMark(
                    x: .value("Date", day.date.toLocaleDateString()),
                    y: .value("Feed time", Double(day.totalInt) / 3600)
                )
            }
            .containerRelativeFrame(.vertical, count: 2, span: 1, spacing: 0)

            Spacer()
        }
        .navigationTitle("Feed data past week")
        .navigationBarTitleDisplayMode(.large)
        .padding()
        .onAppear {
            let date = Calendar.current.startOfDay(for: date)
            let startDate = Calendar.current.date(byAdding: .day, value: -7, to: date)!

            for i in 0 ... 7 {
                let testDate = Calendar.current.date(byAdding: .day, value: i, to: startDate)!
                self.feedService.createDetailsIfUnavailable(testDate, baby: baby)
            }
        }
    }
}
