import Foundation
import os
import SwiftData
import SwiftUI

public class BabyActionService: ObservableObject {
    private let container: ModelContainer
    private let apiService: ApiService

    init(_ container: ModelContainer, _ apiService: ApiService) {
        self.container = container
        self.apiService = apiService
    }

    public func startSleep() -> BabyAction {
        let action = BabyAction()
        action.type = .sleep
        action.start = Date()
        save(action)
        Task {
            apiService.syncAction(action)
        }
        return action
    }

    public func endSleep(_ sleep: BabyAction) {
        sleep.end = Date()
        sleep.syncRequired = true
        Task {
            apiService.syncAction(sleep)
        }
    }

    public func startFeed() -> BabyAction {
        let action = BabyAction()
        action.type = .feed
        action.start = Date()
        save(action)
        Task {
            apiService.syncAction(action)
        }
        return action
    }

    public func endFeed(_ feed: BabyAction) {
        feed.end = Date()
        feed.syncRequired = true
        Task {
            apiService.syncAction(feed)
        }
    }

    private func save(_ action: BabyAction) {
        Task {
            await MainActor.run {
                self.container.mainContext.insert(action)
            }
        }
    }
}
