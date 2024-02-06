import SwiftData
import SwiftUI

struct SleepControlView: View {
    @EnvironmentObject
    private var model: BabyViewModel
    @EnvironmentObject
    private var services: ServiceContainer

    @Query()
    var sleepQuery: [SleepAction]

    @State
    private var sleepDuration = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State
    private var detailsModel: DaySleepDetailsModel?

    init(baby: Baby) {
        let type = BabyActionType.sleep.rawValue
        let babyId = baby.persistentModelID
        let filter = #Predicate<SleepAction> { action in
            action.action ?? "" == type &&
                action.end == nil &&
                action.baby?.persistentModelID == babyId
        }
        var fetchDescriptor = FetchDescriptor<SleepAction>(predicate: filter)
        fetchDescriptor.fetchLimit = 1
        _sleepQuery = Query(fetchDescriptor)
    }

    var sleep: SleepAction? { sleepQuery.first }

    var body: some View {
        VStack {
            if let sleep = self.sleep {
                HStack {
                    Image(systemName: "moon.fill")
                    Text("Sleeping \(sleepDuration.formatAsDurationString())")
                    Spacer()

                    VStack(alignment: .trailing) {
                        DatePicker("", selection: Binding(get: { sleep.start }, set: { newValue in
                            sleep.start = newValue
                            startDateUpdate()
                            updateSleepDuration()
                        }),
                        displayedComponents: .hourAndMinute)
                        if !sleep.start.isSameDateIgnoringTime(as: Date()) {
                            Text(sleep.start.formatDateAsRelativeString())
                                .font(.footnote)
                                .foregroundStyle(Color.white.opacity(0.25))
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

                Toggle(isOn: Binding(get: { sleep.night ?? false }, set: { newValue in
                    sleep.night = newValue
                    model.updateAction(sleep)
                })) {
                    Text("Night")
                }
            }
            else {
                HStack {
                    Image(systemName: "moon.fill")
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
            if let details = detailsModel {
                SleepDetailsView(details: details)
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
        .onAppear {
            getSleepDetails()
        }
    }

    private func getSleepDetails() {
        Task {
            detailsModel = await services.sleepService.getSleepDetails(Date())
            print(detailsModel!)
        }
    }

    private func startDateUpdate() {
        let endDate = Date()
        if let sleep = sleep {
            let startDate = sleep.start
            let later = endDate.isTimeLaterThan(date: startDate)
            let sameDay = startDate.isSameDateIgnoringTime(as: endDate)

            if endDate < startDate, startDate.isSameDateIgnoringTime(as: endDate) {
                sleep.start = Calendar.current.date(byAdding: .day, value: -1, to: startDate)!
            }
            else if !later, !sameDay {
                sleep.start = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
            }

            model.updateAction(sleep)
        }
    }

    private func updateSleepDuration() {
        if let sleep = sleep {
            sleepDuration = max(0, Int(Date().timeIntervalSince(sleep.start)))
        }
    }
}
