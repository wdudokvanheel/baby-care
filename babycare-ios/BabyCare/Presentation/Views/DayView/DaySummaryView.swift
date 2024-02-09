import SwiftData
import SwiftUI

struct DaySummaryView: View {
    // TODO: Move this to the viewmodel
    let sleepRepo: SleepService
    let feedRepo = FeedRepository()
    let bottleRepo = BottleRepository()

    @ObservedObject
    var model: BabyViewModel

    var date: Date

    @Query()
    var sleepItems: [SleepAction]
    @Query()
    var feedItems: [FeedAction]
    @Query()
    var bottleItems: [BottleAction]

    @State
    private var feedDetails: DayFeedDetailsModel?

    init(_ model: BabyViewModel, _ date: Date) {
        self.model = model
        self.date = date
        self.sleepRepo = model.services.actionMapperService.getService(type: .sleep)

        _sleepItems = sleepRepo.createQueryByDate(model.baby, date)
        _feedItems = feedRepo.createQueryByDate(model.baby, date)
        _bottleItems = bottleRepo.createQueryByDate(model.baby, date)

        sleepRepo.createDetailsIfUnavailable(date, baby: model.baby)
    }

    var body: some View {
        VStack {
            if !sleepItems.isEmpty {
                VStack {
                    HStack {
                        Image(systemName: "moon.fill")
                        Text("Sleep data")
                        Spacer()
                    }
                    SleepDetailsView(date, model.baby)
                    SleepLogView(sleepService: model.services.actionMapperService.getService(type: .sleep), items: sleepItems)
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
                    HStack {
                        Image(systemName: "fork.knife.circle")
                        Text("Feed data")
                        Spacer()
                    }
                    if let details = feedDetails {
                        FeedDetailsView(details: details)
                    }
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

    func updateDetails() {
        Task {
//            self.sleepDetails = await model.babyServices.sleepService.getNewSleepDetails(date, model.baby)
//            self.feedDetails = await model.babyServices.feedService.getFeedDetails(date)
        }
    }
}
