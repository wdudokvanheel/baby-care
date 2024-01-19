import SwiftUI

@main
struct BabyCareApp: App {
    public static let API_URL = "http://10.0.0.21:8080/api"

    var body: some Scene {
        WindowGroup {
            ServiceInjection {
                MainView()
            }
        }
    }
}
