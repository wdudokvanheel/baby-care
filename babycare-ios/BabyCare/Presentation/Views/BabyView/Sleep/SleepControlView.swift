import SwiftData
import SwiftUI

struct SleepControlView: View {
    @EnvironmentObject private var model: BabyViewModel
    private var sleepService: SleepService

    @Query var sleepQuery: [SleepAction]

    @State private var sleepDuration = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(services: ServiceContainer, baby: Baby) {
        self.sleepService = services.actionMapperService.getService(type: .sleep)

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
            HStack {
                NavigationLink(destination: DayView(model: model)) {
                    Image(systemName: "list.bullet.rectangle.portrait.fill")
                }
                .isDetailLink(false)

                Spacer()
                Image(systemName: "moon.fill")
                Text("Sleep")
                Spacer()

                NavigationLink(destination: SleepWeekGraph(Date(), model.baby, sleepService: sleepService)) {
                    Image(systemName: "chart.bar.fill")
                }
            }
            .font(.title3)

            SleepDetailsView(Date(), model.baby)

            if let sleep = self.sleep {
                VStack {
                    HStack {
                        RefreshingInterval(date: sleep.start)
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

                    Toggle(isOn: Binding(get: { sleep.night ?? false }, set: { newValue in
                        sleep.night = newValue
                        self.sleepService.update(sleep)
                    })) {
                        Text("Night")
                    }

                    Button(action: {
                        sleepService.stop(sleep)
                    }) {
                        HStack {
                            Image(systemName: "stop.circle")
                            Text("Stop Sleep")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.indigo.opacity(0.9))
                }
                .multilineTextAlignment(.center)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.black.opacity(0.2))
                )
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
            }
            else {
                Button(action: {
                    sleepService.start(model.baby)
                }) {
                    HStack {
                        Image(systemName: "play.circle")
                        Text("Start sleeping")
                    }
                    .frame(maxWidth: .infinity)
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

            sleepService.update(sleep)
        }
    }

    private func updateSleepDuration() {
        if let sleep = sleep {
            sleepDuration = max(0, Int(Date().timeIntervalSince(sleep.start)))
        }
    }
}

struct RefreshingInterval: View {
    let date: Date

    @State private var sleepDuration = 0

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Text("Sleeping \(sleepDuration.formatAsDurationString(excludeHours: true))")
            .onReceive(timer) { _ in
                updateSleepDuration()
            }
    }

    private func updateSleepDuration() {
        sleepDuration = max(0, Int(Date().timeIntervalSince(date)))
    }
}
