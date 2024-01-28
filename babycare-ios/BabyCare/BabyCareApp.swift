import SwiftUI

@main
struct BabyCareApp: App {
    @UIApplicationDelegateAdaptor(BabyCareDelegate.self)
    private var appDelegate

    public static var DEBUG_MODE = false
    public static var API_URL = "https://baby.ducknugget.com/api"

    init() {
        #if DEBUG
            setDebugValues()
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ServiceInjection(delegate: self.appDelegate) {
                MainView()
            }
        }
    }

    private func setDebugValues() {
        BabyCareApp.DEBUG_MODE = true
        BabyCareApp.API_URL = "http://10.0.0.21:6000/api"
    }
}
