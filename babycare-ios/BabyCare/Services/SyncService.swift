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
        syncNow()
    }

    private func syncAction(_ dto: BabyActionDto) async {
        let action = await actionService.getByRemoteId(dto.id)

        if let action = action {
            await MainActor.run {
                print("\tUpdating action #\(dto.id)")
                action.update(source: dto)
            }
        } else {
            print("\tAdding action #\(dto.id)")
            let newAction = BabyAction(from: dto)
            await actionService.save(newAction)
        }
    }

    public func syncNow() {
        print("Syncing from: \(syncedUntilTimestamp)")
        Task {
            let dto = BabyActionSyncRequestDto(syncedUntilTimestamp)

            let actionsUpdated = await withCheckedContinuation { continuation in
                apiService.performRequest(dto: dto, path: "action/sync", method: "POST") { data in
                    if let response: BabyActionSyncResponseDto = (self.apiService.parseJson(responseData: data) as BabyActionSyncResponseDto?) {
                        if response.actions.count > 0 {
                            Task {
                                print("Syncing \(response.actions.count) actions:")
                                for action in response.actions {
                                    await self.syncAction(action)
                                }
                                print("Sync complete, up to date until: \(response.syncedDate)")
                                self.syncedUntilTimestamp = response.syncedDate

                                // Continue the outer task
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
            }
            if actionsUpdated > 0 {
                print("Got more to sync")
                syncNow()
            }
        }
    }
}

func performOnMainThread<T>(operation: @escaping () async -> T) async -> T {
    await withCheckedContinuation { continuation in
        DispatchQueue.main.async {
            Task {
                let result = await operation()
                continuation.resume(returning: result)
            }
        }
    }
}
