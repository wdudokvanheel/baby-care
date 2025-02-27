import Charts
import SwiftData
import SwiftUI

struct FeedGraphView: View {
    let baby: Baby
    let sleepService: FeedService

    @Query var query: [DailyFeedDetails]
    @State var date: Date = .init()
    @State var scrollPosition: String = Date().formatted(.dateTime.month().day())

    init(_ baby: Baby, _ sleepService: FeedService) {
        self.baby = baby
        self.sleepService = sleepService

        _query = FeedingCareViewModel.feedDetailsPastMonthQuery(date, baby)
    }

    var body: some View {
        BackgroundView {
            VStack {
                Chart(query, id: \.persistentModelID) { day in
                    let dayLabel = day.date.formatted(.dateTime.month().day())

                    BarMark(
                        x: .value("Date", dayLabel),
                        y: .value("Total feed time", Double(day.totalInt) / 60)
                    )
                    .foregroundStyle(Color("FeedingColor"))
                    .cornerRadius(8)
                }
                .containerRelativeFrame(.vertical, count: 5, span: 2, spacing: 0)
                .chartScrollableAxes(.horizontal)
                .chartScrollPosition(x: $scrollPosition)
                .chartXVisibleDomain(length: 7)
                .chartScrollTargetBehavior(.valueAligned(unit: 1))
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisValueLabel {
                            if let minutes = value.as(Double.self) {
                                Text("\(Int(minutes))m")
                            }
                        }
                        AxisTick()
                        AxisGridLine()
                    }
                }
                Spacer()
            }
            .navigationTitle("Feeding data")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
        .onAppear {
            if let last = query.last {
                self.scrollPosition = last.date.formatted(.dateTime.month().day())
            }

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
