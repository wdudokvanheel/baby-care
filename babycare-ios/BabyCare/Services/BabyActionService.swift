import Foundation
import os
import SwiftData
import SwiftUI

public class BabyActionService: ObservableObject {
    private let container: ModelContainer
    private let apiService: ApiService
    private let babyService: BabyService

    init(_ container: ModelContainer, _ apiService: ApiService, _ babyService: BabyService) {
        self.container = container
        self.apiService = apiService
        self.babyService = babyService
    }

    public func startAction(baby: Baby, type: BabyActionType) -> BabyAction {
        let action = BabyAction()
        action.baby = baby
        action.syncRequired = true
        action.type = type
        action.start = Date()
        Task {
            apiService.syncActionRemote(action)
            await save(action)
        }
        return action
    }

    public func endAction(baby: Baby, action: BabyAction) {
        action.baby = baby
        action.end = Date()
        action.syncRequired = true
        Task {
            apiService.syncActionRemote(action)
        }
    }

    public func insertOrUpdateAction(_ dto: BabyActionDto, forBaby: Baby? = nil) async {
        let action = await getByRemoteId(dto.id)

        var forBaby = forBaby

        if forBaby == nil {
            forBaby = await babyService.getByRemoteId(Int(dto.babyId))
        }

        guard let baby = forBaby else {
            return
        }

        if let action = action {
            await MainActor.run {
                print("Updating action #\(dto.id)")
                action.baby = baby
                action.update(source: dto)
            }
        } else {
            print("Adding action #\(dto.id)")
            let newAction = BabyAction(from: dto)
            newAction.baby = baby
            await save(newAction)
        }
    }

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
            } catch {
                print("Erorr \(error)")
            }
            return nil
        }
    }

    public func getUnsavedActions() async -> [BabyAction] {
        return await MainActor.run {
            let descriptor = FetchDescriptor<BabyAction>(predicate: #Predicate {
                $0.syncRequired == true
            })

            do {
                let result = try container.mainContext.fetch(descriptor)
                if result.count > 0 {
                    return result
                }
            } catch {
                print("Erorr \(error)")
            }
            return []
        }
    }

    public func save(_ action: BabyAction) async {
        await MainActor.run {
            self.container.mainContext.insert(action)
        }
    }
}
