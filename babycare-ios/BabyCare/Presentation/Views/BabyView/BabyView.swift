
import SwiftUI

struct BabyView: View {
    @EnvironmentObject
    var services: ServiceContainer

    var model: BabyViewModel

    init(model: BabyViewModel) {
        self.model = model
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(model.baby.displayName)'s data")
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 0)
            
            if model.services.prefService.isPanelVisible(model.baby, .sleep) {
                //                SleepControlView(services: model.services, baby: model.baby)
                let model = SleepCareViewModel(baby: model.baby, services: model.services)
                SleepCareView(model: model)

                //                SleepControlView(services: self.model.services, baby: model.baby)
            }

            if model.services.prefService.isPanelVisible(model.baby, .feed) {
                //                FeedControlView(services: model.services, date: Date(), baby: model.baby)
                BreastFeedingCare()
            }
            if model.services.prefService.isPanelVisible(model.baby, .bottle) {
                // BottleControlView(baby: model.baby)
            }
        }
        .padding(0)
//        .navigationBarTitle("\(model.baby.displayName)")
        .environmentObject(model)
    }
}
