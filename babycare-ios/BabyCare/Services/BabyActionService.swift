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
        Task {
            apiService.syncAction(action)
            await save(action)
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
        Task {
            apiService.syncAction(action)
            await save(action)
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

    public func updateStorage() {}

    public func getByRemoteId(_ id: Int64) async -> BabyAction? {
        await MainActor.run {
            var descriptor = FetchDescriptor<BabyAction>(predicate: #Predicate {
                $0.remoteId == id
            })

            descriptor.fetchLimit = 1

            do {
                let result = try container.mainContext.fetch(descriptor)
                if result.count > 0 {
                    return result[0]
                }
            }
            catch {
                print("Erorr \(error)")
            }
            return nil
        }
    }

    public func save(_ action: BabyAction) async {
        await MainActor.run {
            self.container.mainContext.insert(action)
        }
    }
}
