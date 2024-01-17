import Foundation
import os
import SwiftData
import SwiftUI

class MainViewModel: ObservableObject {
    private let dataContainer: ModelContainer
    private let actionService: BabyActionService

    @Published
    public var sleep: BabyAction?
    @Published
    public var feed: BabyAction?

    init(dataContainer: ModelContainer) {
        self.dataContainer = dataContainer
        self.actionService = BabyActionService(container: dataContainer)
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
