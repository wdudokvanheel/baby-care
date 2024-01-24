import SwiftData
import SwiftUI

struct FeedControlView: View {
    @EnvironmentObject
    private var model: BabyViewModel

    @Query()
    var feedQuery: [BabyAction]

    @State
    private var feedDuration = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(baby: Baby) {
        let type = BabyActionType.feed.rawValue

        let babyId = baby.persistentModelID
        let filter = #Predicate<BabyAction> { action in
            action.action ?? "" == type &&
                action.end == nil &&
                action.baby?.persistentModelID == babyId
        }

        _feedQuery = Query(filter: filter)
    }

    var feed: BabyAction? { feedQuery.first }

    var body: some View {
        VStack {
            if let feed = self.feed {
                HStack {
                    Image(systemName: "fork.knife.circle")
                        .font(.title2)
                    Text("Feeding for \(formatDuration(feedDuration))")
                    Spacer()
                }
                .font(.title3)
                .onReceive(timer) { _ in
                    updateSleepDuration()
                }
                .onChange(of: feed) {
                    updateSleepDuration()
                }
                .onAppear {
                    updateSleepDuration()
                }

                Button("Stop Feed") {
                    model.stopFeed(feed)
                }
                .buttonStyle(.borderedProminent)
                .tint(.mint)
            }
            else {
                HStack {
                    Image(systemName: "fork.knife.circle")
                        .font(.title2)

                    Text("Feed")
                    Spacer()
                }
                .font(.title3)
                
                Button("Start Feed") {
                    model.startFeed()
                }
                .buttonStyle(.borderedProminent)
                .tint(.mint)
            }
        }
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.mint.opacity(0.5))
        )
    }

    private func updateSleepDuration() {
        if let startTime = feed?.start {
            feedDuration = max(0, Int(Date().timeIntervalSince(startTime)))
        }
    }

    private func formatDuration(_ totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
