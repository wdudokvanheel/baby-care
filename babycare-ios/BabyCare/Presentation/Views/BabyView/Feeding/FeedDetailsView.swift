import Foundation
import os
import SwiftUI

struct FeedDetailsView: View {
    var details: DayFeedDetailsModel
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("Left\n\(details.feedingTimeLeft.formatAsDurationString(false))")
                    .multilineTextAlignment(.leading)
                Spacer()
                Text("Total feeding\n\(details.feedingTimeTotal.formatAsDurationString(false))")
                    .multilineTextAlignment(.center)
                Spacer()
                Text("Right\n\(details.feedingTimeRight.formatAsDurationString(false))")
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
