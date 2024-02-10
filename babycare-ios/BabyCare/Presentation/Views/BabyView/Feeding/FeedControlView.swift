import SwiftData
import SwiftUI

struct FeedControlView: View {
    @EnvironmentObject
    private var model: BabyViewModel
    private var feedService: FeedService

    @Query()
    var feedQuery: [FeedAction]

    @State
    private var feedDuration = 0

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(services: ServiceContainer, baby: Baby) {
        self.feedService = services.actionMapperService.getService(type: .feed)

        let type = BabyActionType.feed.rawValue

        let babyId = baby.persistentModelID
        let filter = #Predicate<FeedAction> { action in
            action.action ?? "" == type &&
                action.end == nil &&
                action.deleted != true &&
                action.baby?.persistentModelID == babyId
        }
        var fetchDescriptor = FetchDescriptor<FeedAction>(predicate: filter)
        fetchDescriptor.fetchLimit = 1

        _feedQuery = Query(fetchDescriptor)
    }

    var feed: FeedAction? { feedQuery.first }

    var body: some View {
        VStack {
            if let feed = self.feed {
                HStack {
                    Image(systemName: "fork.knife.circle")
                        .font(.title2)
                    Text("Feeding \(formatDuration(feedDuration))")
                    Spacer()

                    VStack(alignment: .trailing) {
                        DatePicker("", selection: Binding(get: { feed.start }, set: { newValue in
                            feed.start = newValue
                            startDateUpdate()
                            updatefeedDuration()
                        }),
                        displayedComponents: .hourAndMinute)
                        if !feed.start.isSameDateIgnoringTime(as: Date()) {
                            Text(feed.start.formatDateAsRelativeString())
                                .font(.footnote)
                                .foregroundStyle(Color.white.opacity(0.25))
                        }
                    }
                }
                .font(.body)
                .onReceive(timer) { _ in
                    updatefeedDuration()
                }
                .onChange(of: feed) {
                    updatefeedDuration()
                }
                .onAppear {
                    updatefeedDuration()
                }

                HStack {
                    Button("L") {
                        feedService.setFeedSide(feed, .left)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(feed.feedSide == .left ? .mint : .mint.opacity(0.3))

                    Spacer()

                    Button("Stop feeding") {
                        feedService.stop(feed)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.mint.opacity(0.9))

                    Spacer()

                    Button("R") {
                        feedService.setFeedSide(feed, .right)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(feed.feedSide == .right ? .mint : .mint.opacity(0.3))
                }
            }
            else {
                HStack {
                    Image(systemName: "fork.knife.circle")
                        .font(.title2)

                    Text("Feed")
                    Spacer()
                }
                .font(.title3)

                HStack {
                    Button("L") {
                        feedService.start(model.baby, .left)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.mint)

                    Spacer()

                    Button("Start feeding") {
                        feedService.start(model.baby)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.mint)

                    Spacer()

                    Button("R") {
                        feedService.start(model.baby, .right)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.mint)
                }
            }
            FeedDetailsView(Date(), model.baby)
            FeedLog(model)
        }
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.mint.opacity(0.5))
        )
    }

    private func startDateUpdate() {
        let endDate = Date()
        if let feed = feed {
            let startDate = feed.start
            let later = endDate.isTimeLaterThan(date: startDate)
            let sameDay = startDate.isSameDateIgnoringTime(as: endDate)

            if endDate < startDate, startDate.isSameDateIgnoringTime(as: endDate) {
                feed.start = Calendar.current.date(byAdding: .day, value: -1, to: startDate)!
            }
            else if !later, !sameDay {
                feed.start = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
            }

            feedService.update(feed)
        }
    }

    private func updatefeedDuration() {
        if let feed = feed {
            feedDuration = max(0, Int(Date().timeIntervalSince(feed.start)))
        }
    }

    private func formatDuration(_ totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
