import Combine
import Foundation
import os
import SwiftData
import SwiftUI

class MainViewModel: ObservableObject {
    public let services: BabyCareServiceContainer

    @Published
    public var sleep: BabyAction?
    @Published
    public var feed: BabyAction?
    @Published
    public var showLogin = false

    public init(_ services: BabyCareServiceContainer) {
        self.services = services
        services.syncService.syncNow()
    }

    public func login() {
        showLogin.toggle()
    }

    public func logout() {
        // TODO: Do this in a better way, an enum for each key (app-wide) and just delete all keys
        UserDefaults.standard.removeObject(forKey: "com.bitechular.babycare.data.syncedUntil")
        UserDefaults.standard.synchronize()
        Task {
            await MainActor.run {
                do {
                    try services.container.mainContext.delete(model: BabyAction.self)
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
            self.services.syncService.syncNow()
        }
    }

    public func update() {
        services.actionService.updateStorage()
    }

    public func toggleSleep() {
        if let current = sleep {
            services.actionService.endSleep(current)
            sleep = nil
        }
        else {
            sleep = services.actionService.startSleep()
        }
    }

    public func toggleFeed() {
        if let current = feed {
            services.actionService.endFeed(current)
            feed = nil
        }
        else {
            feed = services.actionService.startFeed()
        }
    }
}
