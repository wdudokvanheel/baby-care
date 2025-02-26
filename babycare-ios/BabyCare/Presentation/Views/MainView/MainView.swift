import SwiftUI

struct MainView: View {
    @EnvironmentObject
    private var model: MainViewModel
    var body: some View {
        BackgroundView {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 20) {
                        AuthGuard(model.services.authService) {
                            VStack(alignment: .center, spacing: 8) {
                                BabyView()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .padding(0)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarHidden(true)
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 16)
                    .padding(.horizontal, 24)
                    
                    UnAuthGuard(model.services.authService) {
                        Button("Login") {
                            model.login()
                        }
                        .font(.footnote)
                        .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .introspect(.navigationStack, on: .iOS(.v16, .v17)) {
                $0.viewControllers.forEach { controller in
                    controller.view.backgroundColor = .clear
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTransition(.flip(axis: .vertical))
        }
        .padding(0)
        .sheet(isPresented: $model.showLogin, content: LoginView.init)
    }
}
