import Charts
import SwiftData
import SwiftUI

struct SleepGraphView: View {
    let baby: Baby
    let sleepService: SleepService

    @Query var query: [DailySleepDetails]
    @State var date: Date = .init()
    @State var scrollPosition: String = Date().formatted(.dateTime.month().day())

    init(_ baby: Baby, _ sleepService: SleepService) {
        self.baby = baby
        self.sleepService = sleepService

        _query = SleepCareViewModel.sleepDetailsPastMonthQuery(date, baby)
    }

    var body: some View {
        BackgroundView {
            VStack {
                Chart(query, id: \.persistentModelID) { day in
                    let dayLabel = day.date.formatted(.dateTime.month().day())

                    BarMark(
                        x: .value("Day", dayLabel),
                        y: .value("Night", Double(day.sleepTimeNightInt) / 3600)
                    )
                    .foregroundStyle(by: .value("Night", "Night"))
                    .cornerRadius(8)

                    BarMark(
                        x: .value("Date", dayLabel),
                        y: .value("Naps", Double(day.sleepTimeDayInt) / 3600)
                    )
                    .foregroundStyle(by: .value("Naps", "Naps"))
                    .cornerRadius(8)
                }
                .chartForegroundStyleScale([
                    "Night": Color("SleepColor"), "Naps": Color("NapColor")
                ])
                .containerRelativeFrame(.vertical, count: 5, span: 2, spacing: 0)
                .chartScrollableAxes(.horizontal)
                .chartScrollPosition(x: $scrollPosition)
                .chartXVisibleDomain(length: 7)
                .chartScrollTargetBehavior(.valueAligned(unit: 1))
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisValueLabel {
                            if let hours = value.as(Double.self) {
                                Text("\(Int(hours))h")
                            }
                        }
                        AxisTick()
                        AxisGridLine()
                    }
                }
                Spacer()
            }
            .navigationTitle("Sleep data")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
        .onAppear {
            // Make sure a detail view exists for these days
            let date = Calendar.current.startOfDay(for: date)
            let startDate = Calendar.current.date(byAdding: .day, value: -31, to: date)!

            for i in 0 ... 31 {
                let testDate = Calendar.current.date(byAdding: .day, value: i, to: startDate)!
                self.sleepService.createDetailsIfUnavailable(testDate, baby: baby)
            }
        }
    }
}
