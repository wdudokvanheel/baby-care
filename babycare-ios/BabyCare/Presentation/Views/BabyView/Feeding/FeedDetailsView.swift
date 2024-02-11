import Foundation
import SwiftData
import SwiftUI

struct FeedDetailsView: View {
    let date: Date
    let baby: Baby

    init(_ date: Date, _ baby: Baby) {
        self.date = date
        self.baby = baby
    }

    var body: some View {
        FeedDetailsContainer(date, baby) { details in
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
}
