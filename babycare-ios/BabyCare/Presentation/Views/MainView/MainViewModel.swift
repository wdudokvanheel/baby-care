import Combine
import Foundation
import os
import SwiftData
import SwiftUI

class MainViewModel: ObservableObject {
    public let services: ServiceContainer

    @Published
    public var showLogin = false

    public init(_ services: ServiceContainer) {
        self.services = services
        services.syncService.syncWhenAuthenticated()
    }

    public func login() {
        showLogin.toggle()
    }

    public func logout() {
        // TODO: Do this in a better way, an enum for each key (app-wide) and just delete all keys
        UserDefaults.standard.removeObject(forKey: "com.bitechular.babycare.data.syncedBabiesUntil")
        UserDefaults.standard.synchronize()
        Task {
            await MainActor.run {
                do {
                    try services.container.mainContext.delete(model: Baby.self)
                    try services.container.mainContext.delete(model: BabyAction.self)
                    try services.container.mainContext.delete(model: SleepAction.self)
                    try services.container.mainContext.delete(model: FeedAction.self)
                    try services.container.mainContext.delete(model: BottleAction.self)
                    try services.container.mainContext.delete(model: DailySleepDetails.self)
                    try services.container.mainContext.delete(model: DailyFeedDetails.self)
                    try services.container.mainContext.save()
                }
                catch {}
            }
        }

        services.authService.logout()
    }

    public func authenticate(_ email: String, _ password: String) {
        services.apiService.authenticate(email, password) {
            self.services.notificationService.registerForNotifications()
        }
    }
}
