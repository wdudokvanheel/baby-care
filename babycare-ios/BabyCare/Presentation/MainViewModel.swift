import Foundation
import os
import SwiftUI

class MainViewModel: ObservableObject {
    private let container = CoreDataContainerController()

    @Published
    public var sleep: BabyAction?
    @Published
    public var feed: BabyAction?

    public func toggleSleep() {
        if let current = sleep {
            endSleep(current)
            sleep = nil
        }
        else {
            sleep = startSleep()
        }
    }

    public func toggleFeed() {
        if let current = feed {
            endFeed(current)
            feed = nil
        }
        else {
            feed = startFeed()
        }
    }

    public func startSleep() -> BabyAction {
        let action = BabyAction(context: container.getContext())
        action.type = .sleep
        action.start = Date()
        container.save()
        return action
    }

    public func endSleep(_ sleep: BabyAction) {
        sleep.end = Date()
        container.save()
    }

    public func startFeed() -> BabyAction {
        let action = BabyAction(context: container.getContext())
        action.type = .feed
        action.start = Date()
        container.save()
        return action
    }

    public func endFeed(_ feed: BabyAction) {
        feed.end = Date()
        container.save()
    }
}
