import Combine
import Foundation
import os
import SwiftData
import SwiftUI

class MainViewModel: ObservableObject {
    private let actionService: BabyActionService

    @Published
    public var sleep: BabyAction?
    @Published
    public var feed: BabyAction?

    public init(_ services: BabyCareServiceContainer) {
        self.actionService = services.actionService
    }

    public func update() {
        actionService.updateStorage()
    }

    public func toggleSleep() {
        if let current = sleep {
            actionService.endSleep(current)
            sleep = nil
        }
        else {
            sleep = actionService.startSleep()
        }
    }

    public func toggleFeed() {
        if let current = feed {
            actionService.endFeed(current)
            feed = nil
        }
        else {
            feed = actionService.startFeed()
        }
    }
}
