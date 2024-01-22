import SwiftUI

@main
struct BabyCareApp: App {
    @UIApplicationDelegateAdaptor(BabyCareDelegate.self)
    private var appDelegate

    public static let API_URL = "http://10.0.0.21:6000/api"

    var body: some Scene {
        WindowGroup {
            ServiceInjection(delegate: self.appDelegate) {
                MainView()
            }
        }
    }
}
