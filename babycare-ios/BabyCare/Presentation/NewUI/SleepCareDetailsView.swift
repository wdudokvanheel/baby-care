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

        let date = Calendar.current.startOfDay(for: date)
        let babyId = baby.persistentModelID

        let filter = #Predicate<DailySleepDetails> { details in
            details.baby?.persistentModelID == babyId &&
                details.date == date
        }

        var fetchDescriptor = FetchDescriptor<DailySleepDetails>(predicate: filter)
        fetchDescriptor.fetchLimit = 1
        _query = Query(fetchDescriptor)
    }

    public var body: some View {
        HStack(spacing: 16) {
            InfoTile(
                "Last Night",
                "moon.zzz",
                details.sleepTimeNightInt.formatAsDurationString(false),
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
                "Naps",
                "sun.max",
                details.sleepTimeDayInt.formatAsDurationString(false),
                Color("SleepColor")
            )
            .frame(maxWidth: .infinity)
        }
        .padding(0)
        .frame(maxWidth: .infinity)
    }
}
