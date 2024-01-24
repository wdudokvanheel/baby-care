import SwiftUI

struct MainView: View {
    @EnvironmentObject
    private var model: MainViewModel
    @State
    private var currentDate = Date()

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                AuthButton(authService: model.services.authService)

                AuthGuard(model.services.authService) {
                    BabySelector { baby in
                        VStack {

                            LatestActionsView(baby: baby)
                        }
                    }
                }
            }
            .padding()
            .navigationBarTitle("Little Tiny Baby Care")
            .onReceive(timer) { input in
                currentDate = input
            }
            .sheet(isPresented: $model.showLogin, content: LoginView.init)
        }
    }

    func timeDifference(from date: Date?) -> String {
        guard let startDate = date else { return "Unknown" }

        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: currentDate)

        var timeString = ""
        if let hour = components.hour, hour > 0 {
            timeString += "\(hour):"
        }

        let minute = components.minute ?? 0
        let second = components.second ?? 0

        timeString += String(format: "%02d:%02d", minute, second)
        return timeString
    }
}
