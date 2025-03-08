import SwiftData
import SwiftUI

public struct SleepCareView: View {
    @ObservedObject var model: SleepCareViewModel

    @Query var activeSleepQuery: [SleepAction]
    var activeSleepAction: SleepAction? { activeSleepQuery.first }

    // All actions for the current day
    @Query var sleepActions: [SleepAction]

    var hasSleepAction: Binding<Bool> {
        Binding<Bool>(
            get: { self.activeSleepAction != nil && self.activeSleepAction?.end == nil },
            set: { _ in }
        )
    }

    init(model: SleepCareViewModel) {
        self.model = model
        _sleepActions = model.sleepActionsSelectedDate()
        _activeSleepQuery = model.activeSleepQuery()
    }

    public var body: some View {
        VStack(spacing: 16) {
            VStack {
                PanelHeader("Sleep statistics")
                SleepCareDetailView(model.date, model.baby)
            }

            VStack {
                PanelHeader("Recent activity")
                SleepListView(date: model.date, items: self.sleepActions) {
                    print("Clicked \($0.remoteId ?? -1)")
                }
            }

            VStack {
                PanelHeader("This week")
                NavigationLink(destination: SleepGraphView(model.baby, model.services.sleepService)) {
                    Panel {
                        VStack {
                            SleepGraphPreview(Date(), model.baby, model.services.sleepService)
                                .frame(height: 125)
                                .frame(maxWidth: .infinity)
                                .padding(0)
                        }
                        .padding(0)
                    }
                    .padding(0)
                }
                .padding(.bottom, 4)
            }
        }
        .onAppear {
            model.updateDailyDetails(model.date, model.baby)
        }
        .padding(0)
    }
}
