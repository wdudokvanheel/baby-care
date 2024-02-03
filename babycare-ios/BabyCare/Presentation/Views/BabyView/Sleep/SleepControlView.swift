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
                action.deleted == false &&
                action.baby?.persistentModelID == babyId
        }
        var fetchDescriptor = FetchDescriptor<BabyAction>(predicate: filter)
        fetchDescriptor.fetchLimit = 1
        _sleepQuery = Query(fetchDescriptor)
    }

    var sleep: BabyAction? { sleepQuery.first }

    var body: some View {
        VStack {
            if let sleep = self.sleep {
                HStack {
                    Image(systemName: "moon")
                    Text("Sleeping \(formatDuration(sleepDuration))")
                    Spacer()

                    if let start = sleep.start {
                        VStack(alignment: .trailing) {
                            DatePicker("", selection: Binding(get: { start }, set: { newValue in
                                sleep.start = newValue
                                startDateUpdate()
                                updateSleepDuration()
                            }),
                            displayedComponents: .hourAndMinute)
                            if !start.isSameDateIgnoringTime(as: Date()) {
                                Text(start.formatDateAsRelativeString())
                                    .font(.footnote)
                                    .foregroundStyle(Color.white.opacity(0.25))
                            }
                        }
                    }
                }
                .font(.body)
                .onReceive(timer) { _ in
                    updateSleepDuration()
                }
                .onChange(of: sleep) {
                    updateSleepDuration()
                }
                .onAppear {
                    updateSleepDuration()
                }

                Button("Stop sleeping") {
                    model.stopSleep(sleep)
                }
                .buttonStyle(.borderedProminent)
                .tint(.indigo.opacity(0.9))
            }
            else {
                HStack {
                    Image(systemName: "moon")
                    Text("Sleep")
                    Spacer()
                }
                .font(.title3)

                Button("Start sleeping") {
                    model.startSleep()
                }
                .buttonStyle(.borderedProminent)
                .tint(.indigo)
            }
            SleepLog(model)
        }
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.indigo.opacity(0.5))
        )
    }

    private func startDateUpdate() {
        let endDate = Date()
        if let sleep = sleep, let startDate = sleep.start {
            let later = endDate.isTimeLaterThan(date: startDate)
            let sameDay = startDate.isSameDateIgnoringTime(as: endDate)

            if endDate < startDate, startDate.isSameDateIgnoringTime(as: endDate) {
                sleep.start = Calendar.current.date(byAdding: .day, value: -1, to: startDate)
            }
            else if !later, !sameDay {
                sleep.start = Calendar.current.date(byAdding: .day, value: 1, to: startDate)
            }

            model.updateAction(sleep)
        }
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
