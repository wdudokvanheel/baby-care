import Charts
import Foundation
import os
import SwiftData
import SwiftUI

struct SleepWeekGraph: View {
    @Query
    var query: [DailySleepDetails]

    let date: Date
    let baby: Baby

    init(_ date: Date, _ baby: Baby, sleepService: SleepService) {
        self.date = date
        self.baby = baby

        let date = Calendar.current.startOfDay(for: date)
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: date)!

        for i in 0 ... 7 {
            let testDate = Calendar.current.date(byAdding: .day, value: i, to: startDate)!
            sleepService.createDetailsIfUnavailable(testDate, baby: baby)
        }

        let babyId = baby.persistentModelID

        let filter = #Predicate<DailySleepDetails> { details in
            details.baby?.persistentModelID == babyId &&
                details.date >= startDate &&
                details.date <= date
        }

        var fetchDescriptor = FetchDescriptor<DailySleepDetails>(predicate: filter, sortBy: [SortDescriptor<DailySleepDetails>(\.date, order: .reverse)])
        fetchDescriptor.fetchLimit = 7
        _query = Query(fetchDescriptor)
    }

    var body: some View {
        VStack {
            Chart(query, id: \.persistentModelID) { day in
                BarMark(
                    x: .value("Day", day.date.toLocaleDateString()),
                    y: .value("Night", Double(day.sleepTimeNightInt) / 3600)
                )
                .foregroundStyle(by: .value("Night", "Night"))

                BarMark(
                    x: .value("Date", day.date.toLocaleDateString()),
                    y: .value("Day", Double(day.sleepTimeDayInt) / 3600)
                )
                .foregroundStyle(by: .value("Day", "Day"))
            }
            .chartForegroundStyleScale([
                "Night": .blue, "Day": .indigo
            ])

            Spacer()
        }
        .navigationTitle("Sleep data past week")
        .navigationBarTitleDisplayMode(.large)
        .padding()
    }
}
