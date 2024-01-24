import SwiftData
import SwiftUI

struct SleepControlView: View {
    @EnvironmentObject
    private var model: BabyViewModel

    @Query()
    var sleepQuery: [BabyAction]

    @State
    private var sleepDuration = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(baby: Baby) {
        let type = BabyActionType.sleep.rawValue
        let babyId = baby.persistentModelID
        let filter = #Predicate<BabyAction> { action in
            action.action ?? "" == type &&
                action.end == nil &&
                action.baby?.persistentModelID == babyId
        }

        _sleepQuery = Query(filter: filter)
    }

    var sleep: BabyAction? { sleepQuery.first }

    var body: some View {
        VStack {
            if let sleep = self.sleep {
                HStack {
                    Image(systemName: "moon")
                    Text("Sleeping for \(formatDuration(sleepDuration))")
                    Spacer()
                }
                .font(.title3)
                .onReceive(timer) { _ in
                    updateSleepDuration()
                }
                .onChange(of: sleep) {
                    updateSleepDuration()
                }
                .onAppear {
                    updateSleepDuration()
                }

                Button("Stop Sleep") {
                    model.stopSleep(sleep)
                }
                .buttonStyle(.borderedProminent)
                .tint(.indigo)
            }
            else {
                HStack {
                    Image(systemName: "moon")
                    Text("Sleep")
                    Spacer()
                }
                .font(.title3)


                Button("Start Sleep") {
                    model.startSleep()
                }
                .buttonStyle(.borderedProminent)
                .tint(.indigo)
            }
        }
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.indigo.opacity(0.5))
        )
    }

    private func updateSleepDuration() {
        if let startTime = sleep?.start {
            sleepDuration = max(0, Int(Date().timeIntervalSince(startTime)))
        }
    }

    private func formatDuration(_ totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
