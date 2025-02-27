import SwiftData
import SwiftUI

public struct FeedingCare: View {
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
            HStack {
                Text("Breast Feeding")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("TextDark"))
                    .padding(.top, 0)
                Spacer()
            }
            .padding(0)

            FeedingCareDetailView(Date(), model.baby)

            ExpandingButton(label: "Start feeding", icon: "arrowtriangle.right.circle", color: Color("FeedingColor"), expanded: hasFeedAction, action: model.buttonStartFeeding, content: {
                if let action = self.activeFeedAction {
                    ActiveFeedingView(action)
                }
            })

            NavigationLink(destination: FeedGraphView(model.baby, model.services.feedService)){
                Panel {
                    VStack {
                        FeedingGraphPreview(Date(), model.baby, model.services.feedService)
                            .frame(height: 125)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(0)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                }
            }
            
            Spacer()
        }
        .padding(0)
        .environmentObject(model)
    }
}
