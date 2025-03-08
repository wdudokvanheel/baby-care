import SwiftData
import SwiftUI

struct FeedControlView: View {
    @EnvironmentObject private var model: BabyViewModel
    private let date: Date
    private var feedService: FeedService

    @Query var currentFeedQuery: [FeedAction]
    @Query var previousFeedQuery: [FeedAction]
    @Query var detailsQuery: [DailyFeedDetails]

    @State private var feedDuration = 0

    var currentFeed: FeedAction? { currentFeedQuery.first }
    var previousFeed: FeedAction? { previousFeedQuery.first }

    var lastFeedSide: FeedSide? {
        previousFeed?.feedSide ?? nil
    }

    var details: DailyFeedDetails? {
        guard !detailsQuery.isEmpty else {
            return nil
        }
        return detailsQuery[0]
    }

    var mostFeedSide: FeedSide? {
        guard let details = details else {
            return nil
        }

        if details.leftInt == details.rightInt {
            return nil
        }

        if details.leftInt > details.rightInt {
            return .left
        }
        return .right
    }

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(services: ServiceContainer, date: Date, baby: Baby) {
        self.feedService = services.actionMapperService.getService(type: .feed)
        self.date = date

        _currentFeedQuery = createCurrentFeedQuery(baby: baby)
        _previousFeedQuery = createPreviousFeedQuery(baby: baby)
        _detailsQuery = FeedService.createQueryDetailsByDate(date, baby)
    }

    private func createCurrentFeedQuery(baby: Baby) -> Query<FeedAction, [FeedAction]> {
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

        return Query(fetchDescriptor)
    }

    private func createPreviousFeedQuery(baby: Baby) -> Query<FeedAction, [FeedAction]> {
        let type = BabyActionType.feed.rawValue
        let babyId = baby.persistentModelID
        let filter = #Predicate<FeedAction> { action in
            action.action ?? "" == type &&
                action.end != nil &&
                action.deleted != true &&
                action.baby?.persistentModelID == babyId
        }
        var fetchDescriptor = FetchDescriptor<FeedAction>(predicate: filter, sortBy: [SortDescriptor<FeedAction>(\.end, order: .reverse)])
        fetchDescriptor.fetchLimit = 1

        return Query(fetchDescriptor)
    }

    // TODO: Clean up this view
    var body: some View {
        VStack {
            HStack {
                NavigationLink(destination: DayView(model: model)) {
                    Image(systemName: "list.bullet.rectangle.portrait.fill")
                }
                .isDetailLink(false)

                Spacer()
                Image(systemName: "fork.knife.circle")
                    .font(.title2)
                Text("Feed")
                Spacer()
                NavigationLink(destination: FeedWeekGraph(Date(), model.baby, feedService: feedService)) {
                    Image(systemName: "chart.bar.fill")
                }
            }
            .font(.title3)

            if let details = details {
                FeedDetailsView(details: details)
            }

            if let feed = self.currentFeed {
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
                    Button {
                        feedService.setFeedSide(feed, .left)
                    } label: {
                        HStack {
                            Image(systemName: "l.circle.fill")
                            Text("Left")
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(feed.feedSide == .left ? .orange : .orange.opacity(0.3))

                    Spacer()

                    Button {
                        feedService.stop(feed)
                    } label: {
                        HStack {
                            Image(systemName: "stop.circle")
                            Text("Stop")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange.opacity(0.9))

                    Spacer()

                    Button {
                        feedService.setFeedSide(feed, .right)
                    } label: {
                        HStack {
                            Spacer()
                            Text("Right")
                            Image(systemName: "r.circle.fill")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(feed.feedSide == .right ? .orange : .orange.opacity(0.3))
                }
            }
            else {
                HStack {
                    Button {
                        feedService.start(model.baby, .left)
                    } label: {
                        HStack {
                            Image(systemName: "l.circle.fill")
                            Spacer()
                            if lastFeedSide == .right {
                                Image(systemName: "arrow.counterclockwise.circle")
                                    .foregroundStyle(.black)
                                    .opacity(0.5)
                            }
                            if mostFeedSide == .right {
                                Image(systemName: "plus.circle")
                                    .foregroundStyle(.black)
                                    .opacity(0.5)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)

                    Spacer()

                    Button {
                        feedService.start(model.baby)
                    } label: {
                        HStack {
                            Image(systemName: "play.circle")
                            Text("Start")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)

                    Spacer()

                    Button {
                        feedService.start(model.baby, .right)
                    } label: {
                        HStack {
                            if lastFeedSide == .left {
                                Image(systemName: "arrow.counterclockwise.circle")
                                    .foregroundStyle(.black)
                                    .opacity(0.5)
                            }
                            if mostFeedSide == .left {
                                Image(systemName: "plus.circle")
                                    .foregroundStyle(.black)
                                    .opacity(0.5)
                            }
                            Spacer()
                            Image(systemName: "r.circle.fill")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                }
            }

            if let lastFeed = self.previousFeed, let date = lastFeed.end {
                HStack {
                    Spacer()
                    ElapsedTimeText(startDate: date)
                        .opacity(0.75)
                    Spacer()
                }
            }
        }
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.orange.opacity(0.5))
        )
    }

    private func startDateUpdate() {
        let endDate = Date()
        if let feed = currentFeed {
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
        if let feed = currentFeed {
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
