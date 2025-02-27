import Charts
import Foundation
import os
import SwiftData
import SwiftUI

struct SleepGraphPreview: View {
    @Query
    var query: [DailySleepDetails]

    let sleepService: SleepService
    let date: Date
    let baby: Baby

    init(_ date: Date, _ baby: Baby, _ sleepService: SleepService) {
        self.date = date
        self.baby = baby
        self.sleepService = sleepService

        _query = SleepCareViewModel.sleepDetailsPastWeekQuery(date, baby)
    }

    var body: some View {
        Chart(query, id: \.persistentModelID) { day in
            BarMark(
                x: .value("Date", day.date.formatted(.dateTime.weekday(.abbreviated))),
                y: .value("Naps", Double(day.sleepTimeDayInt) / 3600)
            )
            .foregroundStyle(by: .value("Naps", "Naps"))
            .cornerRadius(8)
            
            BarMark(
                x: .value("Day", day.date.formatted(.dateTime.weekday(.abbreviated))),
                y: .value("Night", Double(day.sleepTimeNightInt) / 3600)
            )
            .foregroundStyle(by: .value("Night", "Night"))
            .cornerRadius(8)

        }
        .padding(0)
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
            "Night": Color("SleepColor"), "Naps": Color("SleepColor")
        ])
        .onAppear {
            let date = Calendar.current.startOfDay(for: date)
            let startDate = Calendar.current.date(byAdding: .day, value: -7, to: date)!

            for i in 0 ... 7 {
                let testDate = Calendar.current.date(byAdding: .day, value: i, to: startDate)!
                self.sleepService.createDetailsIfUnavailable(testDate, baby: baby)
            }
        }
    }
}
