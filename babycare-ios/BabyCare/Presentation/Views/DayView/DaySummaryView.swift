import SwiftData
import SwiftUI

struct DaySummaryView: View {
    // TODO: Move this to the viewmodel
    let sleepRepo = SleepRepository()
    let feedRepo = FeedRepository()
    let bottleRepo = BottleRepository()

    @ObservedObject
    var model: BabyViewModel
    @Binding
    var date: Date

    @Query()
    var sleepItems: [BabyAction]
    @Query()
    var feedItems: [FeedAction]
    @Query()
    var bottleItems: [BottleAction]

    init(_ model: BabyViewModel, _ date: Binding<Date>) {
        self.model = model
        self._date = date
        _sleepItems = sleepRepo.createQueryByDate(model.baby, date.wrappedValue)
        _feedItems = feedRepo.createQueryByDate(model.baby, date.wrappedValue)
        _bottleItems = bottleRepo.createQueryByDate(model.baby, date.wrappedValue)
    }

    var body: some View {
        VStack {
            if !sleepItems.isEmpty {
                VStack {
                    Text("Sleeping")
                    SleepLogView(model: model, items: sleepItems)
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.indigo.opacity(0.5))
                )
            }

            if !feedItems.isEmpty {
                VStack {
                    Text("Feeding")
                    FeedLogView(model: model, items: feedItems)
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.mint.opacity(0.5))
                )
            }

            if !bottleItems.isEmpty {
                VStack {
                    Text("Bottles")
                    BottleLogView(model: model, items: bottleItems)
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.brown.opacity(0.5))
                )
            }
        }
        .padding()
    }
}
