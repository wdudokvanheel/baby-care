
import SwiftUI

struct BabyView: View {
    var model: BabyViewModel

    var body: some View {
        VStack(spacing: 16) {
            SleepControlView(baby: model.baby)
            FeedControlView(baby: model.baby)
            BottleControlView(baby: model.baby)
        }
        .navigationBarTitle("\(model.baby.displayName)")
        .environmentObject(model)
    }
}
