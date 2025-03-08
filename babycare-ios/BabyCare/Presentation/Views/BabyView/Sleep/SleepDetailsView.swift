import Foundation
import os
import SwiftData
import SwiftUI

struct SleepDetailsView: View {
    let date: Date
    let baby: Baby

    @Query var query: [DailySleepDetails]

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

    var body: some View {
        VStack {
            if details.bedTime != nil || details.wakeTime != nil {
                HStack {
                    HStack(alignment: .top) {
                        Image(systemName: "sunset")
                        if let bedTime = details.bedTime {
                            Text("Bed time\n\(bedTime.formatTime())")
                        }
                        else {
                            Text("n/a")
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.black.opacity(0.2))
                    )
                    Spacer()
                    HStack(alignment: .top) {
                        Image(systemName: "sunrise")
                        if let wakeTime = details.wakeTime {
                            Text("Wake up\n\(wakeTime.formatTime())")
                        }
                        else {
                            Text("n/a")
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.black.opacity(0.2))
                    )
                }
                .font(.body)
                .multilineTextAlignment(.center)
            }
            HStack(alignment: .center) {
                Text("Last night\n\(details.sleepTimeNightInt.formatAsDurationString(false))")
                Spacer()
                Text("Total sleep\n\(details.sleepTimeTotal.formatAsDurationString(false))")
                Spacer()
                Text("\(details.napsInt > 0 ? "\(details.napsInt) " : "")Naps\n\(details.sleepTimeDayInt.formatAsDurationString(false))")
            }
            .frame(maxWidth: .infinity)
//            .font(.footnote)
            .multilineTextAlignment(.center)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.black.opacity(0.2))
            )
        }
    }
}
