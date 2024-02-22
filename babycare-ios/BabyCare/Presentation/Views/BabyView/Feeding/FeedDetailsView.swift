import Foundation
import SwiftData
import SwiftUI

struct FeedDetailsView: View {
    let details: DailyFeedDetails

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("Left breast\n\(details.leftPercentage)%")
                    .multilineTextAlignment(.leading)
                Spacer()
                Text("Total\n\(details.totalInt.formatAsDurationString(false))")
                    .multilineTextAlignment(.center)
                Spacer()
                Text("Right breast\n\(details.rightPercentage)%")
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
