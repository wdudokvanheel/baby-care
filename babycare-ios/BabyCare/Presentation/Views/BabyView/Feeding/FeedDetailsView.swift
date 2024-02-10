import Foundation
import SwiftData
import SwiftUI

struct FeedDetailsView: View {
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

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("Left\n\(details.leftInt.formatAsDurationString(false))")
                    .multilineTextAlignment(.leading)
                Spacer()
                Text("Total\n\(details.totalInt.formatAsDurationString(false))")
                    .multilineTextAlignment(.center)
                Spacer()
                Text("Right\n\(details.rightInt.formatAsDurationString(false))")
                    .multilineTextAlignment(.trailing)
            }
            .frame(maxWidth: .infinity)
            .font(.footnote)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.black.opacity(0.2))
            )
        }
    }
}
