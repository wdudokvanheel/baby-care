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
                    VStack {
                        ScrollView {
                            if let baby = baby {
                                BabyView(model: BabyViewModel(services: model.services, baby: baby))
                            }
                        }
                        BabySelector(selected: self.$baby)
                    }
                    .padding(0)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(trailing: NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                            .imageScale(.large)
                    })
                }

                UnAuthGuard(model.services.authService) {
                    Button("Login") {
                        model.login()
                    }
                    .font(.footnote)
                    .foregroundColor(.white)
                }
            }

            .padding()
            .sheet(isPresented: $model.showLogin, content: LoginView.init)
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .navigationViewStyle(.stack)
            .onAppear {
                Task {
                    self.baby = await self.model.services.babyService.getAllBabies().first
                }
            }
        }
    }
}
