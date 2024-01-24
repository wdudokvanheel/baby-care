
import SwiftUI

struct BabyView: View {
    var model: BabyViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text("\(model.baby.displayName)")
                .font(.largeTitle)
                .foregroundColor(.white)
            
            SleepControlView(baby: model.baby)
            FeedControlView(baby: model.baby)
        }
        .environmentObject(model)
    }
}
