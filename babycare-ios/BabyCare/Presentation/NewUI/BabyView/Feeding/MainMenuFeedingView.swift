import SwiftData
import SwiftUI

struct MainMenuFeedingView: View {
    @ObservedObject var model: FeedingCareViewModel

    @Query var activeFeedQuery: [FeedAction]
    var activeFeedAction: FeedAction? { activeFeedQuery.first }

    var hasFeedAction: Binding<Bool> {
        Binding<Bool>(
            get: { self.activeFeedAction != nil && self.activeFeedAction?.end == nil },
            set: { _ in }
        )
    }

    init(model: FeedingCareViewModel) {
        self.model = model
        _activeFeedQuery = model.activeFeedQuery()
    }

    var body: some View {
        ExpandingButton(label: "Start feeding", icon: "arrowtriangle.right.circle", color: Color("FeedingColor"), expanded: hasFeedAction, action: model.buttonStartFeeding, content: {
            if let action = self.activeFeedAction {
                ActiveFeedingView(action, model)
            }
        })
    }
}
