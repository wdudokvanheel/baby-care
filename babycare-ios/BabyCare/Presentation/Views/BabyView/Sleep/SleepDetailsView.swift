import Foundation
import os
import SwiftUI

struct SleepDetailsView: View {
    var details: DaySleepDetailsModel

    var body: some View {
        VStack {
            if details.bedTime != nil || details.wakeTime != nil{
                HStack {
                    HStack(alignment: .top) {
                        Image(systemName: "moon")
                        if let bedTime = details.bedTime{
                            Text("Bed time\n\(bedTime.formatTime())")
                        }
                        else{
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
                        Image(systemName: "sun.max")
                        if let wakeTime = details.wakeTime{
                            Text("Wake up\n\(wakeTime.formatTime())")
                        }
                        else{
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
                Text("Last night\n\(details.sleepTimeNight.formatAsDurationString(false))")
                Spacer()
                Text("Total sleep\n\(details.sleepTimeTotal.formatAsDurationString(false))")
                Spacer()
                Text("Naps\n\(details.sleepTimeDay.formatAsDurationString(false))")
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

struct TodaySleepDetailsView: View {
    @ObservedObject
    var service: SleepService

    var body: some View {
        SleepDetailsView(details: service.detailsToday)
    }
}
