import Foundation
import os
import SwiftData
import SwiftUI

public class SyncService: ObservableObject {
    @AppStorage("com.bitechular.babycare.data.syncedUntil")
    private var syncedUntilTimestamp: Int = 0

    private let apiService: ApiService
    private let actionService: BabyActionService
    private let container: ModelContainer

    init(_ apiService: ApiService, _ babyActionService: BabyActionService, _ container: ModelContainer) {
        self.apiService = apiService
        self.actionService = babyActionService
        self.container = container
    }

    public func resetSyncDate() {
        syncedUntilTimestamp = 0
    }

    public func syncActions() {
        Task {
            await getNewActions()
            await sendUnsavedActions()
        }
    }

    private func sendUnsavedActions() async {
        print("Syncing unsaved actions")
        await self.actionService.getUnsavedActions().forEach{ action in
            self.apiService.syncActionRemote(action)
        }
    }

    private func getNewActions() async {
        print("Retrieving new actions, synced until: \(syncedUntilTimestamp)")
        let dto = BabyActionSyncRequestDto(syncedUntilTimestamp)

        let actionsUpdated = await withCheckedContinuation { continuation in
            apiService.performRequest(dto: dto, path: "action/sync", method: "POST") { data in
                if let response: BabyActionSyncResponseDto = (self.apiService.parseJson(responseData: data) as BabyActionSyncResponseDto?) {
                    if response.actions.count > 0 {
                        Task {
                            print("Syncing \(response.actions.count) actions:")
                            for action in response.actions {
                                await self.actionService.insertOrUpdateAction(action)
                            }
                            print("Sync complete, up to date until: \(response.syncedDate)")
                            self.syncedUntilTimestamp = response.syncedDate

                            continuation.resume(returning: response.actions.count)
                        }
                    } else {
                        continuation.resume(returning: 0)
                    }
                } else {
                    print("Error parsing response")
                    continuation.resume(returning: -1)
                }
            } onError: {
                print("Error in sync request")
                continuation.resume(returning: -1)
            }
        }

        if actionsUpdated == -1 {
            print("Failed to sync")
        } else if actionsUpdated > 0 {
            print("Got more to sync")
            await getNewActions()
        }
    }
}
