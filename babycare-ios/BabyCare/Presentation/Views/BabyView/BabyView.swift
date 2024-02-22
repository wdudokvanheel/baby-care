
import SwiftUI

struct BabyView: View {
    var model: BabyViewModel

    init(model: BabyViewModel) {
        self.model = model
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if model.services.prefService.isPanelVisible(model.baby, .sleep) {
                SleepControlView(services: model.services, baby: model.baby)
            }
            if model.services.prefService.isPanelVisible(model.baby, .feed) {
                FeedControlView(services: model.services, date: Date(), baby: model.baby)
            }
            if model.services.prefService.isPanelVisible(model.baby, .bottle) {
                BottleControlView(baby: model.baby)
            }
        }
        .navigationBarTitle("\(model.baby.displayName)")
        .environmentObject(model)
    }
}
