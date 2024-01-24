import Combine
import Foundation
import SwiftData
import SwiftUI

public class SyncService: ObservableObject {
    // TODO: Replace key with enums and a storage service
    @AppStorage("com.bitechular.babycare.data.syncedBabiesUntil")
    private var syncedBabiesUntilTimestamp: Int = 0

    private let apiService: ApiService
    private let babyService: BabyService
    private let actionService: BabyActionService
    private let authService: AuthenticationService
    private let container: ModelContainer

    private var cancellable: Set<AnyCancellable> = .init()

    init(_ apiService: ApiService, _ babyService: BabyService, _ babyActionService: BabyActionService, _ authService: AuthenticationService, _ container: ModelContainer) {
        self.apiService = apiService
        self.babyService = babyService
        self.actionService = babyActionService
        self.authService = authService
        self.container = container
    }

    public func syncWhenAuthenticated() {
        if authService.authenticated {
            startSync()
            return
        }

        print("Not authenticated, waiting for change")
        authService.$authenticated.sink { authenticated in
            print("AUth update")
            if authenticated {
                self.startSync()
            }
        }
        .store(in: &cancellable)
    }

    public func startSync() {
        // TODO: Setup sync scheduler? Or are notifications enough?
        syncBabyData()
    }

    public func resetSyncDate() {
        syncedBabiesUntilTimestamp = 0
    }

    public func syncBabyData() {

        Task {
            await getNewBabies()

            let babies = await babyService.getAllBabies()
            print("\n\nBabies synced, retreiving new actions for \(babies.count) babies")

            for baby in babies {
                print("Syncing actions for \(baby.name ?? "Unnamed")")
                await syncBabyActions(baby)
            }

            await sendUnsavedActions()
        }
    }

    private func sendUnsavedActions() async {
        print("Syncing unsaved actions")
        await actionService.getUnsavedActions().forEach { action in
            self.apiService.syncActionRemote(action)
        }
    }

    private func syncBabyActions(_ baby: Baby) async {
        print("Retrieving new actions, synced until: \(baby.lastSync ?? 0)")
        let dto = SyncRequestDto(Int(baby.lastSync ?? 0))

        let actionsUpdated = await withCheckedContinuation { continuation in
            guard let babyId = baby.remoteId else {
                print("Baby \(baby.name ?? "Unnamed") has no remoteId")
                continuation.resume(returning: -1)
                return
            }
            apiService.performRequest(dto: dto,
                                      path: "baby/\(babyId)/sync", method: "POST") { data in
                if let response: SyncResponseDto<BabyActionDto> = (self.apiService.parseJson(responseData: data) as SyncResponseDto?) {
                    if response.items.count > 0 {
                        Task {
                            print("Syncing \(response.items.count) actions:")
                            for action in response.items {
                                await self.actionService.insertOrUpdateAction(action, forBaby: baby)
                            }
                            print("Sync complete, up to date until: \(response.syncedDate)")
                            baby.lastSync = Int64(response.syncedDate)

                            continuation.resume(returning: response.items.count)
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
            await syncBabyActions(baby)
        }
    }

    private func getNewBabies() async {
        print("Retrieving new babies, synced until: \(syncedBabiesUntilTimestamp)")
        let dto = SyncRequestDto(syncedBabiesUntilTimestamp)

        let actionsUpdated = await withCheckedContinuation { continuation in
            apiService.performRequest(dto: dto, path: "baby/sync", method: "POST") { data in
                if let response: SyncResponseDto<BabyDto> = (self.apiService.parseJson(responseData: data) as SyncResponseDto<BabyDto>?) {
                    if response.items.count > 0 {
                        Task {
                            print("Syncing \(response.items.count) babies :")
                            for action in response.items {
                                await self.babyService.insertOrUpdateBaby(action)
                            }
                            print("Sync babies complete, up to date until: \(response.syncedDate)")
                            self.syncedBabiesUntilTimestamp = response.syncedDate

                            continuation.resume(returning: response.items.count)
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
            print("Got more babies to sync")
            await getNewBabies()
        }
    }
}
