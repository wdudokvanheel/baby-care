
import SwiftUI

struct BabyView: View {
    var model: BabyViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            NavigationLink(destination: DayView(model: model)) {
                Text("More data")
            }
            .buttonStyle(BorderedProminentButtonStyle())
            SleepControlView(baby: model.baby)
            FeedControlView(baby: model.baby)
            BottleControlView(baby: model.baby)
        }
        .navigationBarTitle("\(model.baby.displayName)")
        .environmentObject(model)
    }
}
