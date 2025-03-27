import Combine
import Foundation
import os
import SwiftData
import SwiftUI

class MainViewModel: ObservableObject {
    public let services: ServiceContainer

    @Published public var showLogin = false

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

    public func authenticate(_ email: String, _ password: String, failed: @escaping () -> Void) {
        services.apiService.authenticate(email, password) { success in
            if success {
                self.services.notificationService.registerForNotifications()
            }
            else {
                failed()
            }
        }
    }

    // Debug only
    public func generateTestData() {
        Task {
            if let baby = await services.babyService.getAllBabies().first {
                let calendar = Calendar.current
                let now = Date()
                
                // Loop over the past 8 days (including today to get complete days)
                for i in 0...8 {
                    // Determine the base date (start of day) for the day i days ago
                    guard let dayStart = calendar.date(byAdding: .day, value: (-8 + i), to: calendar.startOfDay(for: now)) else { continue }
                    
                    // ----- Create the Night Sleep Action -----
                    // Night sleep start: Random time between 18:00 and 20:00 on this day
                    let sleepStartHour = Int.random(in: 18...20)
                    let sleepStartMinute = Int.random(in: 0...59)
                    var sleepStartComponents = calendar.dateComponents([.year, .month, .day], from: dayStart)
                    sleepStartComponents.hour = sleepStartHour
                    sleepStartComponents.minute = sleepStartMinute
                    guard let sleepStart = calendar.date(from: sleepStartComponents) else { continue }
                    
                    // Night sleep end: On the following day, random time between 06:00 and 08:00
                    guard let nextDay = calendar.date(byAdding: .day, value: 1, to: dayStart) else { continue }
                    let sleepEndHour = Int.random(in: 6...8)
                    let sleepEndMinute = Int.random(in: 0...59)
                    var sleepEndComponents = calendar.dateComponents([.year, .month, .day], from: nextDay)
                    sleepEndComponents.hour = sleepEndHour
                    sleepEndComponents.minute = sleepEndMinute
                    guard let sleepEnd = calendar.date(from: sleepEndComponents) else { continue }
                    
                    var nightSleep: SleepAction = services.actionService.createAction(baby: baby, type: .sleep)
                    nightSleep.start = sleepStart
                    nightSleep.end = sleepEnd
                    nightSleep.night = true
                    nightSleep.baby = baby
                    nightSleep.syncRequired = true
                    services.actionService.persistAction(nightSleep)
                    
                    // ----- Create 2-3 Nap (Day Sleep) Actions -----
                    let napCount = Int.random(in: 2...3)
                    for _ in 0..<napCount {
                        // Nap start: Random time between 09:00 and 17:00 on the same day
                        let napHour = Int.random(in: 9...17)
                        let napMinute = Int.random(in: 0...59)
                        var napStartComponents = calendar.dateComponents([.year, .month, .day], from: dayStart)
                        napStartComponents.hour = napHour
                        napStartComponents.minute = napMinute
                        guard let napStart = calendar.date(from: napStartComponents) else { continue }
                        
                        // Nap duration: 30 to 60 minutes
                        let napDuration = Int.random(in: 30...60)
                        guard let napEnd = calendar.date(byAdding: .minute, value: napDuration, to: napStart) else { continue }
                        
                        var nap: SleepAction = services.actionService.createAction(baby: baby, type: .sleep)
                        nap.start = napStart
                        nap.end = napEnd
                        nap.night = false
                        nap.baby = baby
                        nap.syncRequired = true
                        services.actionService.persistAction(nap)
                    }
                    
                    // ----- Create 4-7 Feeding Actions -----
                    let feedCount = Int.random(in: 4...7)
                    for _ in 0..<feedCount {
                        // Feeding start: Random time between 07:00 and 18:00 on the same day
                        let feedHour = Int.random(in: 7...18)
                        let feedMinute = Int.random(in: 0...59)
                        var feedStartComponents = calendar.dateComponents([.year, .month, .day], from: dayStart)
                        feedStartComponents.hour = feedHour
                        feedStartComponents.minute = feedMinute
                        guard let feedStart = calendar.date(from: feedStartComponents) else { continue }
                        
                        // Feeding duration: 3 to 8 minutes
                        let feedDuration = Int.random(in: 3...8)
                        guard let feedEnd = calendar.date(byAdding: .minute, value: feedDuration, to: feedStart) else { continue }
                        
                        var feed: FeedAction = services.actionService.createAction(baby: baby, type: .feed)
                        feed.start = feedStart
                        feed.end = feedEnd
                        // Randomly choose the feed side
                        feed.feedSide = Bool.random() ? .left : .right
                        feed.baby = baby
                        feed.syncRequired = true
                        services.actionService.persistAction(feed)
                    }
                    
                    await services.sleepService.updateSleepDetails(dayStart, baby)
                }
            }
        }
    }

}
