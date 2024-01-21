import Foundation
import os
import SwiftUI

class BabyCareDelegate: NSObject, UIApplicationDelegate {
    var data: DelegateData = .init()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Permission granted")
                self.data.notificationsGranted = true
                Task {
                    let center = UNUserNotificationCenter.current()
                    let authorizationStatus = await center
                        .notificationSettings().authorizationStatus

                    if authorizationStatus == .authorized {
                        await MainActor.run {
                            application.registerForRemoteNotifications()
                        }
                    }
                }

            } else if let error = error {
                print("Error: \(error)")
                self.data.notificationsGranted = false
            }
        }

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        self.data.deviceId = token
    }
}

public class DelegateData {
    @Published
    public var deviceId: String?
    @Published
    public var notificationsGranted: Bool = false
}
