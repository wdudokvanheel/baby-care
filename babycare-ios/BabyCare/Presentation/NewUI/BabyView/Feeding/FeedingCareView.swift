import SwiftData
import SwiftUI

public struct FeedingCareView: View {
    @ObservedObject
    var model: FeedingCareViewModel

    @Query
    var feedingQuery: [FeedAction]
    var activeFeedAction: FeedAction? { feedingQuery.first }
    var hasFeedAction: Binding<Bool> {
        Binding<Bool>(
            get: { self.activeFeedAction != nil && self.activeFeedAction?.end == nil },
            set: { _ in }
        )
    }

    init(model: FeedingCareViewModel) {
        self.model = model
        _feedingQuery = model.activeFeedQuery()
    }

    public var body: some View {
        VStack(spacing: 16) {
            VStack {
                PanelHeader("Breast feeding statistics")
                FeedingCareDetailView(Date(), model.baby)
            }

            VStack {
                PanelHeader("This week")
                NavigationLink(destination: FeedGraphView(model.baby, model.services.feedService)) {
                    Panel {
                        VStack {
                            FeedingGraphPreview(Date(), model.baby, model.services.feedService)
                                .frame(height: 125)
                                .frame(maxWidth: .infinity)
                        }
                        .padding(0)
                        .frame(maxWidth: .infinity, maxHeight: 125)
                    }
                }
            }

        }
        .padding(0)
    }
}
