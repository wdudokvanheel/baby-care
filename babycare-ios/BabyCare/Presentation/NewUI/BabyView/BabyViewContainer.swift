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

    @State private var baby: Baby?

    @State private var openBabySelector: Bool = false

    @State var menuItems: [MenuPanelItem]
    @State private var selectedIndex: Int = 0

    var selectedMenuItem: MenuPanelItem {
        menuItems[selectedIndex]
    }

    var currentView: any View {
        switch selectedMenuItem.type {
            case .sleep:
                let model = SleepCareViewModel(baby: self.baby!, services: self.services)
                return SleepCareView(model: model)
            case .feed:
                let model = FeedingCareViewModel(baby: self.baby!, services: self.services)
                return FeedingCare(model: model)
            default:
                return Text("Error")
        }
    }

    init() {
        let items = [
            MenuPanelItem(label: "Sleep", color: Color("SleepColor"), type: .sleep),
            MenuPanelItem(label: "Feeding", color: Color("FeedingColor"), type: .feed),
            MenuPanelItem(label: "Bottle", color: Color("SleepColor"), type: .bottle)
        ]

        self._menuItems = State(initialValue: items)
    }

    var showBabySelector: Bool {
        babies.count > 1
    }

    var body: some View {
        MenuPanel(items: $menuItems, selectedIndex: $selectedIndex) { VStack(alignment: .leading, spacing: 16) {
            if let baby = baby {
                HStack(alignment: .center) {
                    Spacer()
                    Text("\(baby.displayName)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("TextDark"))
                        .onTapGesture {
                            if showBabySelector {
                                openBabySelector.toggle()
                            }
                        }

                    if showBabySelector {
                        Image(systemName: "chevron.down")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .onTapGesture {
                                if showBabySelector {
                                    openBabySelector.toggle()
                                }
                            }
                            .popOver(isPresented: $openBabySelector, arrowDirection: .up, content: {
                                Picker("Select Baby", selection: $baby) {
                                    ForEach(babies, id: \ .id) { baby in
                                        Text(baby.displayName).tag(baby as Baby?)
                                    }
                                }
                                .pickerStyle(.wheel)
                            })
                    }
                    Spacer()

                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                            .foregroundStyle(Color("TextDark").opacity(0.85))
                            .font(.title3)
                    }
                }
                .padding(.top, 0)
                .padding(.bottom, 8)

                AnyView(currentView)

//                selectedMenuItem.view
//                    if services.prefService.isPanelVisible(baby, .sleep) {
//                        let model = SleepCareViewModel(baby: baby, services: services)
//                        SleepCareView(model: model)
//                        //                SleepControlView(services: self.model.services, baby: model.baby)
//                    }
//
//                    if services.prefService.isPanelVisible(baby, .feed) {
//                        let model = FeedingCareViewModel(baby: baby, services: services)
//                        FeedingCare(model: model)
//                            .environmentObject(model)
//
//                        //                FeedControlView(services: services, date: Date(), baby: baby)
//                        //                    .environmentObject(BabyViewModel(services: services, baby: baby))
//                    }
//
//                    if services.prefService.isPanelVisible(baby, .bottle) {
//                        // BottleControlView(baby: model.baby)
//                    }
            }
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
        .onChange(of: baby) {
            self.openBabySelector = false
        }
        }
    }

    private func updateSelectedBaby() {
        // Don't change self.baby if a value is already selected
        if baby == nil, !babies.isEmpty {
            let prefId = services.prefService.getInt(forKey: "baby.default")
            print(babies)
            DispatchQueue.main.async {
                if let id = prefId {
                    self.baby = babies.filter { $0.remoteId != nil && $0.remoteId! == id }.first ?? babies.first
                } else {
                    self.baby = babies.first
                }
            }
        }
    }
}
