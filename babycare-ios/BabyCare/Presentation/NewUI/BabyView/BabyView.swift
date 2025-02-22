
import SwiftUI

struct BabyView: View {
    @EnvironmentObject
    var services: ServiceContainer
    var baby: Baby

    init(baby: Baby) {
        self.baby = baby
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(baby.displayName)'s data")
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 0)

            if services.prefService.isPanelVisible(baby, .sleep) {
                let model = SleepCareViewModel(baby: baby, services: services)
                SleepCareView(model: model)
                //                SleepControlView(services: self.model.services, baby: model.baby)
            }

            if services.prefService.isPanelVisible(baby, .feed) {
                let model = FeedingCareViewModel(baby: baby, services: services)
                FeedingCare(model: model)
                    .environmentObject(model)

//                FeedControlView(services: services, date: Date(), baby: baby)
//                    .environmentObject(BabyViewModel(services: services, baby: baby))
            }

            if services.prefService.isPanelVisible(baby, .bottle) {
                // BottleControlView(baby: model.baby)
            }
        }
        .padding(0)
    }
}
