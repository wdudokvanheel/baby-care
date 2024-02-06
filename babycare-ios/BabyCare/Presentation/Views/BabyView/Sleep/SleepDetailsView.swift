import Foundation
import SwiftUI
import os


struct SleepDetailsView : View{
    @State
    var details: DaySleepDetailsModel
    var body: some View{
        VStack {
            HStack {
                HStack(alignment: .top) {
                    Image(systemName: "moon")
                    Text("Bed time\n\(details.bedTime.formatTime())")
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
                    Text("Wake up\n\(details.wakeTime.formatTime())")
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

            HStack(alignment: .center) {
                Text("Night\n\(details.sleepTimeNight.formatAsDurationString(false))")
                Spacer()
                Text("Total sleep\n\(details.sleepTimeTotal.formatAsDurationString(false))")
                Spacer()
                Text("Naps\n\(details.sleepTimeDay.formatAsDurationString(false))")
            }
            .frame(maxWidth: .infinity)
            .font(.footnote)
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
