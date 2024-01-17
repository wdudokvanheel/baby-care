import Foundation
import os
import SwiftData
import SwiftUI

public class BabyActionService: ObservableObject {
    private let container: ModelContainer

    init(container: ModelContainer) {
        self.container = container
    }
    
    public func startSleep() -> BabyAction {
        let action = BabyAction()
        action.type = .sleep
        action.start = Date()
        save(action)
        return action
    }

    public func endSleep(_ sleep: BabyAction) {
        sleep.end = Date()
        sleep.syncRequired = true
    }

    public func startFeed() -> BabyAction {
        let action = BabyAction()
        action.type = .feed
        action.start = Date()
        save(action)
        return action
    }
    
    public func endFeed(_ feed: BabyAction) {
        feed.end = Date()
        feed.syncRequired = true
    }
    
    private func save(_ action: BabyAction) {
        Task {
            await MainActor.run {
                self.container.mainContext.insert(action)
            }
        }
    }
}
