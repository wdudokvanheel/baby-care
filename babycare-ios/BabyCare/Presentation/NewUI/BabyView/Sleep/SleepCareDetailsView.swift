import SwiftData
import SwiftUI

public struct SleepCareDetailView: View {
    let date: Date
    let baby: Baby

    @Query()
    var query: [DailySleepDetails]

    var details: DailySleepDetails {
        if query.count > 0 {
            return query[0]
        }
        return DailySleepDetails(date: date)
    }

    init(_ date: Date, _ baby: Baby) {
        self.date = date
        self.baby = baby

        _query = SleepCareViewModel.sleepDetailsQuery(date, baby)
    }

    public var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                InfoTile(
                    "Bed time",
                    "sunset",
                    details.bedTime?.formatTime() ?? "Unknown",
                    Color("SleepColor")
                )
                .frame(maxWidth: .infinity)

                InfoTile(
                    "Wake up",
                    "sunrise",
                    details.wakeTime?.formatTime() ?? "Unknown",
                    Color("SleepColor")
                )
                .frame(maxWidth: .infinity)

                InfoTile(
                    "Last Night",
                    "moon.zzz",
                    details.sleepTimeNightInt.formatAsDurationString(false),
                    Color("SleepColor")
                )
                .frame(maxWidth: .infinity)
            }
            .padding(0)
            .frame(maxWidth: .infinity)

            HStack(spacing: 16) {
                InfoTile(
                    "Napping",
                    "sun.max",
                    details.sleepTimeDayInt.formatAsDurationString(false),
                    Color("SleepColor")
                )
                .frame(maxWidth: .infinity)

                InfoTile(
                    "Total Sleep",
                    "clock",
                    details.sleepTimeTotal.formatAsDurationString(false),
                    Color("SleepColor")
                )
                .frame(maxWidth: .infinity)

                InfoTile(
                    "Week average",
                    "zzz",
                    details.sleepTimeDayInt.formatAsDurationString(false),
                    Color("SleepColor")
                )
                .frame(maxWidth: .infinity)
            }
            .padding(0)
            .frame(maxWidth: .infinity)
        }
    }
}
