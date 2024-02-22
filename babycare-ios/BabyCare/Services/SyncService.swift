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
    private let services: ServiceContainer
    private let container: ModelContainer

    private var cancellable: Set<AnyCancellable> = .init()

    init(_ services: ServiceContainer, _ apiService: ApiService, _ babyService: BabyService, _ babyActionService: BabyActionService, _ authService: AuthenticationService, _ container: ModelContainer) {
        self.services = services
        self.apiService = apiService
        self.babyService = babyService
        self.actionService = babyActionService
        self.authService = authService
        self.container = container
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: setupSyncOnForeground)
    }

    public func syncWhenAuthenticated() {
        authService.$authenticated
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] authenticated in
                if authenticated {
                    self?.startSync()
                } else {
                    self?.stopSync()
                }
            }
            .store(in: &cancellable)
    }

    private func startSync() {
        // TODO: Setup sync scheduler? Or are notifications enough?
        print("Starting sync with \(syncedBabiesUntilTimestamp)")
        syncBabyData()
    }

    private func stopSync() {
        print("Stopping sync")
        syncedBabiesUntilTimestamp = 0
    }

    private func setupSyncOnForeground() {
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
            self.syncBabyData()
        }
    }

    public func syncBabyData() {
        Task {
            await getNewBabies()

            print("Syncing available babies from \(self.syncedBabiesUntilTimestamp)")
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
        let actions = await actionService.getUnsavedActions()
        print("Syncing \(actions.count) unsaved actions")
        actions.forEach { action in
            self.apiService.syncActionRemote(action)
        }
    }

    private func syncBabyActions(_ baby: Baby) async {
        print("Retrieving new actions, synced until: \(baby.lastSync ?? 0)")
        let dto = SyncRequestDto(Int(baby.lastSync ?? 0))

        let decoder = JSONDecoder()
        decoder.userInfo[.serviceContainer] = services

        let actionsUpdated = await withCheckedContinuation { continuation in
            guard let babyId = baby.remoteId else {
                print("Baby \(baby.name ?? "Unnamed") has no remoteId")
                continuation.resume(returning: -1)
                return
            }
            apiService.performRequest(dto: dto, path: "baby/\(babyId)/sync", method: "POST") { data in
                if let response: ActionSyncResponse = (self.apiService.parseJson(responseData: data, decoder) as ActionSyncResponse?) {
                    if response.items.count > 0 {
                        Task {
                            print("Syncing \(response.items.count) actions:")
                            for action in response.items {
                                print("SYNC ACTION: \(action)")
                                await self.actionService.insertOrUpdateAction(action, forBaby: baby)
                            }
                            print("Sync complete, up to date until: \(response.syncedDate)")
                            baby.lastSync = Int64(response.syncedDate)
                            await self.babyService.save(baby)

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
