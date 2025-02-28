import SwiftData
import SwiftUI

struct BabyView: View {
    @EnvironmentObject
    var services: ServiceContainer

    @Query private var babies: [Baby]

    @State private var baby: Baby?

    @State private var openMenu: Bool = false

    var showBabySelector: Bool {
        babies.count > 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let baby = baby {
                HStack(alignment: .center) {
                    Spacer()
                    Text("\(baby.displayName)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("TextDark"))
                        .onTapGesture {
                            if showBabySelector {
                                openMenu.toggle()
                            }
                        }

                    if showBabySelector {
                        Image(systemName: "chevron.down")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .onTapGesture {
                                if showBabySelector {
                                    openMenu.toggle()
                                }
                            }
                            .popOver(isPresented: $openMenu, arrowDirection: .up, content: {
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

                if services.prefService.isPanelVisible(baby, .sleep) {
                    let model = SleepCareViewModel(baby: baby, services: services)
                    SleepCareView(model: model)
                    //                SleepControlView(services: self.model.services, baby: model.baby)
                }

                if services.prefService.isPanelVisible(baby, .feed) {
                    let model = FeedingCareViewModel(baby: baby, services: services)
                    FeedingCare(model: model)
                        .environmentObject(model)

                    //                FeedControlView(services: services, date: Date(), baby: baby)
                    //                    .environmentObject(BabyViewModel(services: services, baby: baby))
                }

                if services.prefService.isPanelVisible(baby, .bottle) {
                    // BottleControlView(baby: model.baby)
                }
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
            self.openMenu = false
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
