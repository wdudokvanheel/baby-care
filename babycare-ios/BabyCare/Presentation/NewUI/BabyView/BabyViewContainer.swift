import SwiftData
import SwiftUI

enum BabySubView {
    case sleep
    case feed
    case bottle
}

// Manages the bottom menu to select subviews and the baby selector to select babies
struct BabyViewContainer: View {
    @EnvironmentObject
    var services: ServiceContainer

    @Query private var babies: [Baby]
    @State private var selectedBaby: Baby?

    @State var menuItems: [MenuPanelItem]
    @State private var selectedIndex: Int = 0

    var selectedMenuItem: MenuPanelItem {
        menuItems[selectedIndex]
    }

    var currentView: any View {
        if let baby = self.selectedBaby {
            switch selectedMenuItem.type {
            case .sleep:
                let model = SleepCareViewModel(baby: baby, services: self.services)
                return SleepCareView(model: model)
            case .feed:
                let model = FeedingCareViewModel(baby: baby, services: self.services)
                return FeedingCare(model: model)
            default:
                return Text("Error")
            }
        }
        return Text("Loading...")
    }

    init() {
        let items = [
            MenuPanelItem(label: "Sleeping", color: Color("SleepColor"), type: .sleep),
            MenuPanelItem(label: "Feeding", color: Color("FeedingColor"), type: .feed),
            MenuPanelItem(label: "Bottle", color: Color("SleepColor"), type: .bottle)
        ]

        self._menuItems = State(initialValue: items)
    }

    var showBabySelector: Bool {
        babies.count > 1
    }

    var body: some View {
        MenuPanel(items: $menuItems, selectedIndex: $selectedIndex) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .center) {
                    Spacer()
                    BabySelector(babies: self.babies, selectedBaby: $selectedBaby)
                    Spacer()

                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                            .foregroundStyle(Color("TextDark").opacity(0.85))
                            .font(.title3)
                    }
                }
                .padding(.top, 0)
                .padding(.bottom, 8)

                // Show the current view as selected by the menu panel
                AnyView(currentView)
            }
            .padding(.top, 12)
            .padding(.bottom, 16)
            .padding(.horizontal, 24)
            .onAppear {
                // Query data should be available when the view is rendered
                updateSelectedBaby()
            }
            .onChange(of: babies) {
                // In case there is no baby selected and new data is loaded from the API
                updateSelectedBaby()
            }
        }
    }

    private func updateSelectedBaby() {
        // Don't change self.baby if a value is already selected
        if selectedBaby == nil, !babies.isEmpty {
            let prefId = services.prefService.getInt(forKey: "baby.default")
            print(babies)
            DispatchQueue.main.async {
                if let id = prefId {
                    self.selectedBaby = babies.filter { $0.remoteId != nil && $0.remoteId! == id }.first ?? babies.first
                } else {
                    self.selectedBaby = babies.first
                }
            }
        }
    }
}
