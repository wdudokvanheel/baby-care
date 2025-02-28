import SwiftUI

struct MainView: View {
    @EnvironmentObject
    private var model: MainViewModel
    var body: some View {
        BackgroundView {
            NavigationStack {
                AuthGuard(model.services.authService) {
                    BabyViewContainer()
                }

                UnAuthGuard(model.services.authService) {
                    AuthenticationView()
                }
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
    }
}
