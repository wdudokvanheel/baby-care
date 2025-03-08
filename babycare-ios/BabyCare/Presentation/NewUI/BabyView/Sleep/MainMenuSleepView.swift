import SwiftData
import SwiftUI

struct MainMenuSleepView: View {
    @ObservedObject var model: SleepCareViewModel

    @Query var activeSleepQuery: [SleepAction]
    var activeSleepAction: SleepAction? { activeSleepQuery.first }

    var hasSleepAction: Binding<Bool> {
        Binding<Bool>(
            get: { self.activeSleepAction != nil && self.activeSleepAction?.end == nil },
            set: { _ in }
        )
    }

    init(model: SleepCareViewModel) {
        self.model = model
        _activeSleepQuery = model.activeSleepQuery()
    }

    var body: some View {
        ExpandingButton(label: "Start sleeping", icon: "arrowtriangle.right.circle", color: Color("SleepColor"), expanded: hasSleepAction, action: model.buttonStartSleep, content: {
            if let action = self.activeSleepAction {
                ActiveSleepView(action, model)
            }
        })
    }
}
