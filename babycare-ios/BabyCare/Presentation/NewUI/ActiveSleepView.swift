import SwiftUI

public struct ActiveSleepView: View {
    @EnvironmentObject
    private var model: SleepCareViewModel

    let action: SleepAction

    init(_ action: SleepAction) {
        self.action = action
    }

    public var body: some View {
            VStack(spacing: 4) {
                HStack(alignment: .bottom) {
                    Image(systemName: "zzz")
                        .foregroundColor(Color("SleepColor"))
                        .font(.title2)

                    RefreshingElapsedTimeText("Sleeping", action.start)
                        .font(.title3)
                        .foregroundStyle(Color("TextDark"))
                        .fontWeight(.regular)
                    Spacer()
                }

                HStack(alignment: .bottom) {
                    Text("Started sleeping at")
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
                                    model.updateSleepActionStart(action, newValue)
                                }
                            ),
                            displayedComponents: .hourAndMinute
                        )
                        .tint(Color("SleepColor"))
                        .labelsHidden()
                    }
                }

                HStack {
                    Spacer()
                }
                .padding(.vertical, 0)

                // Night toggle
                Toggle(isOn: Binding(get: { action.night ?? false }, set: { newValue in
                    model.updateSleepActionIsNight(action, newValue)
                })) {
                    Text("Night")
                        .foregroundStyle(Color("TextDark"))
                        .font(.body)
                        .fontWeight(.light)
                }
                .tint(Color("SleepColor"))

                // End sleep button
                ActionButton("End Sleep", "stop.circle", Color("SleepColor")) {
                    print("Stopping!")
                    model.buttonStopSleep(action)
                }
                .padding(.top, 8)
            }
            .padding(8)
    }
}
