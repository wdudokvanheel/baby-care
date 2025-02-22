import SwiftUI

public struct ActiveFeedingView: View {
    @EnvironmentObject
    private var model: FeedingCareViewModel

    let action: FeedAction

    init(_ action: FeedAction) {
        self.action = action
    }

    public var body: some View {
        VStack(spacing: 4) {
            HStack(alignment: .bottom) {
                Image(systemName: "zzz")
                    .foregroundColor(Color("FeedingColor"))
                    .font(.title2)

                RefreshingElapsedTimeText("Feeding", action.start)
                    .font(.title3)
                    .foregroundStyle(Color("TextDark"))
                    .fontWeight(.regular)
                Spacer()
            }

            HStack(alignment: .bottom) {
                Text("Started feeding at")
                    .font(.body)
                    .fontWeight(.light)
                    .foregroundStyle(Color("TextDark"))

                Spacer()
                if !action.start.isSameDateIgnoringTime(as: Date()) {
                    Text("(\(action.start.formatDateAsRelativeString()))")
                        .foregroundStyle(Color("TextDark").opacity(0.75))
                        .font(.footnote)
                }

                VStack(alignment: .trailing, spacing: 0) {
                    // TODO: Custom picker label
                    DatePicker(
                        "",
                        selection: Binding(
                            get: { action.start },
                            set: { newValue in
                                model.updateFeedActionStart(action, newValue)
                            }
                        ),
                        displayedComponents: .hourAndMinute
                    )
                    .tint(Color("FeedingColor"))
                    .labelsHidden()
                }
            }

            HStack {
                Spacer()
            }
            .padding(.vertical, 0)

            // End feed button
            ActionButton("End Feeding", "stop.circle", Color("FeedingColor")) {
                print("Stopping!")
                model.buttonStopFeeding(action)
            }
            .padding(.top, 8)
        }
        .padding(8)
    }
}
