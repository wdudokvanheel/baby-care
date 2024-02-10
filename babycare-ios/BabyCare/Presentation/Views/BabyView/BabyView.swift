
import SwiftUI

struct BabyView: View {
    var model: BabyViewModel

    init(model: BabyViewModel) {
        self.model = model
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SleepControlView(services: model.services, baby: model.baby)
            FeedControlView(services: model.services, baby: model.baby)
            BottleControlView(baby: model.baby)
        }
        .navigationBarTitle("\(model.baby.displayName)")
        .environmentObject(model)
    }
}
