import SwiftUI

@main
struct BabyCareApp: App {
    @UIApplicationDelegateAdaptor(BabyCareDelegate.self)
    private var appDelegate

    public static var API_URL = "https://baby.ducknugget.com/api"

    var body: some Scene {
        WindowGroup {
            ServiceInjection(delegate: self.appDelegate) {
                MainView()
            }
        }
    }
}
