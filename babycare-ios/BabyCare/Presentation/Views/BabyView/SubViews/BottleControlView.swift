import SwiftData
import SwiftUI

struct BottleControlView: View {
    @EnvironmentObject
    private var model: BabyViewModel

    @Query()
    var items: [BottleAction]

    @State
    private var bottleDuration = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(baby: Baby) {
        let type = BabyActionType.bottle.rawValue
        let babyId = baby.persistentModelID
        let filter = #Predicate<BottleAction> { action in
            action.action ?? "" == type &&
                action.end == nil &&
                action.baby?.persistentModelID == babyId
        }
        var fetchDescriptor = FetchDescriptor<BottleAction>(predicate: filter)
        fetchDescriptor.fetchLimit = 1
        _items = Query(fetchDescriptor)
    }

    var bottle: BottleAction? { items.first }

    var body: some View {
        VStack {
            if let bottle = self.bottle {
                HStack {
                    Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                    Text("Feeding a bottle for \(formatDuration(bottleDuration))")
                    Spacer()
                }
                .font(.title3)
                .onReceive(timer) { _ in
                    updateBottleDuration()
                }
                .onChange(of: bottle) {
                    updateBottleDuration()
                }
                .onAppear {
                    updateBottleDuration()
                }

                Button("Stop bottle feeding") {
                    model.stopBottle(bottle)
                }
                .buttonStyle(.borderedProminent)
                .tint(.brown.opacity(0.9))
            }
            else {
                HStack {
                    Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                    Text("Bottle feeding")
                    Spacer()
                }
                .font(.title3)

                Button("Start bottle feeding") {
                    model.startBottle()
                }
                .buttonStyle(.borderedProminent)
                .tint(.brown)
            }
//            SleepLog(model)
        }
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.brown.opacity(0.5))
        )
    }

    private func updateBottleDuration() {
        if let startTime = bottle?.start {
            bottleDuration = max(0, Int(Date().timeIntervalSince(startTime)))
        }
    }

    private func formatDuration(_ totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
