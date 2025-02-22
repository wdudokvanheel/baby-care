import SwiftData
import SwiftUI

public struct SleepCareView: View {
    @ObservedObject
    var model: SleepCareViewModel

    @Query
    var sleepQuery: [SleepAction]
    var activeSleepAction: SleepAction? { sleepQuery.first }
    var hasSleepAction: Binding<Bool> {
        Binding<Bool>(
            get: { self.activeSleepAction != nil && self.activeSleepAction?.end == nil },
            set: { _ in }
        )
    }

    init(model: SleepCareViewModel) {
        self.model = model
        _sleepQuery = model.activeSleepQuery()
    }

    public var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Sleep Care")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("TextDark"))
                Spacer()
            }
            .padding(0)

            SleepCareDetailView(Date(), model.baby)

            ExpandingButton(label: "Start sleeping", icon: "arrowtriangle.right.circle", color: Color("SleepColor"), expanded: hasSleepAction, action: model.buttonStartSleep, content: {
                if let action = self.activeSleepAction {
                    ActiveSleepView(action)
                }
            })

            Panel {
                VStack {
                    SleepGraphPreview(Date(), model.baby, model.services.sleepService)
                        .frame(height: 125)
                        .frame(maxWidth: .infinity)
                }
                .padding(0)
                .frame(maxWidth: .infinity, maxHeight: 200)
            }
        }
        .padding(0)
        .environmentObject(model)
    }
}
