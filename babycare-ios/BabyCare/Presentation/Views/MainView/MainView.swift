import SwiftUI

struct MainView: View {
    @EnvironmentObject
    private var model: MainViewModel

    @State
    private var baby: Baby?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                AuthGuard(model.services.authService) {
                    FullscreenPanel {
                        VStack(alignment: .center, spacing: 8) {
                            if let baby = baby {
                                BabyView(model: BabyViewModel(services: model.services, baby: baby))
                            } else {
                                Text("No babies found")
                            }
                        }
                    }
                    .padding(0)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarHidden(true)
//                    .navigationBarItems(leading: NavigationLink(destination: SettingsView()) {
//                        Image(systemName: "line.3.horizontal")
//                            .imageScale(.large)
//                            .foregroundStyle(Color("TextDark"))
//                    })

//                    VStack {
//                        ScrollView {
//                            if let baby = baby {
//                                BabyView(model: BabyViewModel(services: model.services, baby: baby))
//                            }
//                        }
//                        BabySelector(selected: self.$baby)
//                    }
//                    .padding(0)
//                    .navigationBarTitleDisplayMode(.inline)
//                    .navigationBarItems(trailing: NavigationLink(destination: SettingsView()) {
//                        Image(systemName: "gear")
//                            .imageScale(.large)
//                    })
                }

                UnAuthGuard(model.services.authService) {
                    Button("Login") {
                        model.login()
                    }
                    .font(.footnote)
                    .foregroundColor(.white)
                }
            }
            .padding(0)
            .sheet(isPresented: $model.showLogin, content: LoginView.init)
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .navigationViewStyle(.stack)
            .onAppear {
                Task {
                    let babies = await self.model.services.babyService.getAllBabies()
                    let prefId = self.model.services.prefService.getInt(forKey: "baby.default")

                    if self.baby == nil {
                        if let id = prefId {
                            self.baby = babies.filter { $0.remoteId != nil && $0.remoteId! == id }.first ?? babies.first
                        } else {
                            self.baby = babies.first
                        }
                    }
                }
            }
        }
    }
}
