import Foundation
import SwiftUI
import SwiftData
import Charts


struct FeedingGraphPreview: View {
    @Query
    var query: [DailyFeedDetails]

    let feedService: FeedService
    let date: Date
    let baby: Baby

    init(_ date: Date, _ baby: Baby, _ feedService: FeedService) {
        self.date = date
        self.baby = baby
        self.feedService = feedService

        _query = FeedingCareViewModel.feedDetailsPastWeekQuery(date, baby)
    }

    var body: some View {
        Chart(query, id: \.persistentModelID) { day in
            BarMark(
                x: .value("Date", day.date.formatted(.dateTime.weekday(.abbreviated))),
                y: .value("Feed time", Double(day.totalInt) / 3600)
            )
            .foregroundStyle(by: .value("Feed time", "Feed time"))
            .cornerRadius(8)

        }
        .chartLegend(.hidden)
        .chartXAxis {
            AxisMarks { _ in
                AxisValueLabel()
                    .foregroundStyle(Color("TextDark").opacity(0.75))
            }
        }
        .chartYAxis {
            AxisMarks { _ in }
        }
        .chartForegroundStyleScale([
            "Feed time": Color("FeedingColor")
        ])
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
