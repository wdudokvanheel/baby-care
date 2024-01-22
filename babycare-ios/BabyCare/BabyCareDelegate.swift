import Combine
import Foundation
import os
import SwiftUI

class BabyCareDelegate: NSObject, UIApplicationDelegate {
    var data: DelegateData = .init()
    var services: BabyCareServiceContainer?

    public func setServices(services: BabyCareServiceContainer) {
        self.services = services
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self

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
                            print("REgistering")
                            application.registerForRemoteNotifications()
                            print(application.isRegisteredForRemoteNotifications)
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

    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        // Pass any silent data updates to the notifcation service to handle it
        if let services = services {
            if let data = userInfo["data"] as? String {
                DispatchQueue.main.async {
                    services.notificationService.onReceivePushData(data: data)
                }
                completionHandler(.newData)
                return
            }
        }
        completionHandler(.noData)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        print("my token is \(token)")
        data.deviceId = token
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void)
    {
//        print("Got interaction")
    }
}

extension BabyCareDelegate: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        print("Got notification: \(notification.request.content.userInfo)")
//    }
}

public class DelegateData {
    private var cancellables = Set<AnyCancellable>()

    @Published
    public var deviceId: String?
    @Published
    public var notificationsGranted: Bool = false
}

public struct NotificationModel {
    var name: String
    var data: String
}
