import SwiftData
import SwiftUI

public struct FeedingCareDetailView: View {
    let date: Date
    let baby: Baby

    @Query()
    var query: [DailyFeedDetails]

    var details: DailyFeedDetails {
        if query.count > 0 {
            return query[0]
        }
        return DailyFeedDetails(date: date)
    }

    init(_ date: Date, _ baby: Baby) {
        self.date = date
        self.baby = baby

        let date = Calendar.current.startOfDay(for: date)
        let babyId = baby.persistentModelID

        let filter = #Predicate<DailyFeedDetails> { details in
            details.baby?.persistentModelID == babyId &&
                details.date == date
        }

        var fetchDescriptor = FetchDescriptor<DailyFeedDetails>(predicate: filter)
        fetchDescriptor.fetchLimit = 1
        _query = Query(fetchDescriptor)
    }

    public var body: some View {
        HStack(spacing: 16) {
            InfoTile(
                "Left Breast",
                "l.square",
                "\(details.leftPercentage)%",
                Color("FeedingColor")
            )
            .frame(maxWidth: .infinity)

            InfoTile(
                "Total",
                "clock",
                details.totalInt.formatAsDurationString(false),
                Color("FeedingColor")
            )
            .frame(maxWidth: .infinity)

            InfoTile(
                "Right Breast",
                "r.square",
                "\(details.rightPercentage)%",
                Color("FeedingColor")
            )
            .frame(maxWidth: .infinity)
        }
        .padding(0)
        .frame(maxWidth: .infinity)
    }
}
