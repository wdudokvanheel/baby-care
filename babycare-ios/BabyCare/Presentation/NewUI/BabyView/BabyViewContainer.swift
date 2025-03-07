import SwiftData
import SwiftUI

enum BabySubView {
    case sleep
    case feed
    case bottle
}

struct CurrentView {
    let content: any View
    let menuContent: any View

    init(content: any View, menuContent: any View) {
        self.content = content
        self.menuContent = menuContent
    }
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

    // A switch is not the cleanest solution, but since the views are dynamic (the baby can change), it can not use pre-constructed views with the viewbuilder
    // It will return a struct containing both the main view and menu panel view for the currently selected action
    var currentViewN: CurrentView {
        if let baby = selectedBaby {
            switch selectedMenuItem.type {
            case .sleep:
                let model = SleepCareViewModel(baby: baby, services: services)
                return CurrentView(content: SleepCareView(model: model), menuContent: MainMenuSleepView(model: model))
            default:
                return CurrentView(content: Text("Error"), menuContent: Text("Error"))
            }
        }
        return CurrentView(content: Text("Error"), menuContent: Text("Error"))
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
        let view = currentViewN
        MenuPanel(items: $menuItems, selectedIndex: $selectedIndex) {
            VStack(alignment: .leading, spacing: 0) {
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
                .padding(.horizontal, 24)
                .padding(.vertical, 0)

                // Show the current view as selected by the menu panel
                ScrollView {
                    AnyView(view.content)
                        .padding(.horizontal, 24)
                }
                .padding(0)

                VStack {
//                    ExpandingButton(label: "Test", icon: "sun.max", color: Color("FeedingColor"), expanded: $expand, action: {
//                        self.expand.toggle()
//                    }) {
//                        VStack {
//                            Text("Sup")
//                            Text("Sup")
//                            Text("Sup")
//                        }
//                        .onTapGesture {
//                            self.expand.toggle()
//                        }
//                    }
//                    .padding(.vertical, 0)
//                    .padding(.horizontal, 24)
                    AnyView(view.menuContent)
                        .padding(.vertical, 0)
                        .padding(.horizontal, 24)
                }
                .frame(maxWidth: .infinity)
//                .background(Color.red)
                .padding(.top, 16)
                .background(
                    VStack {
                        Rectangle()
                            .foregroundColor(Color("MenuLine"))
                            .frame(height: 1)
                            .shadow(color: .black, radius: 4, x: 0, y: -2)
                        Spacer()
                    }
                )
            }
            .padding(.top, 12)
            .padding(.bottom, 16)
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
