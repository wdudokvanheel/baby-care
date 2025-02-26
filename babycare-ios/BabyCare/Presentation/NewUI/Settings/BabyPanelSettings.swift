import SwiftUI

struct BabyPanelSettings: View {
    let baby: Baby
    let prefService: UserPreferencesService

    @State
    private var sleepEnabled: Bool
    @State
    private var feedEnabled: Bool
    @State
    private var bottleEnabled: Bool

    init(baby: Baby, prefService: UserPreferencesService) {
        self.baby = baby
        self.prefService = prefService

        if let id = baby.remoteId {
            _sleepEnabled = State(initialValue: prefService.getBool(forKey: "baby.panel.\(id).sleep.visible") ?? true)
            _feedEnabled = State(initialValue: prefService.getBool(forKey: "baby.panel.\(id).feed.visible") ?? true)
            _bottleEnabled = State(initialValue: prefService.getBool(forKey: "baby.panel.\(id).bottle.visible") ?? true)
        } else {
            _sleepEnabled = State(initialValue: true)
            _feedEnabled = State(initialValue: true)
            _bottleEnabled = State(initialValue: true)
        }
    }

    var body: some View {
        //        Section(header: Text("\(baby.displayName)'s panels")) {

        VStack(alignment: .leading, spacing: 16) {
            Text("\(baby.displayName)'s panels")
                .foregroundStyle(Color("TextDark"))
                .fontWeight(.medium)
                .font(.headline)
            
            Panel {
                VStack(spacing: 4) {
                    Toggle(isOn: $sleepEnabled) {
                        Text("Sleep panel")
                    }
                    .onChange(of: sleepEnabled) {
                        if let id = baby.remoteId {
                            prefService.save(sleepEnabled, forKey: "baby.panel.\(id).sleep.visible")
                        }
                    }

                    Toggle(isOn: $feedEnabled) {
                        Text("Feed panel")
                    }
                    .onChange(of: feedEnabled) {
                        if let id = baby.remoteId {
                            prefService.save(feedEnabled, forKey: "baby.panel.\(id).feed.visible")
                        }
                    }

                    Toggle(isOn: $bottleEnabled) {
                        Text("Bottle panel")
                    }
                    .onChange(of: bottleEnabled) {
                        if let id = baby.remoteId {
                            prefService.save(bottleEnabled, forKey: "baby.panel.\(id).bottle.visible")
                        }
                    }
                }
                .foregroundColor(Color("TextDark"))
                .font(.body)
                .tint(Color("SleepColor"))
                .padding(4)
            }
            
        }
        .padding(.top, 16)
    }
}
