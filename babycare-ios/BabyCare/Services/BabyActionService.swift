import Foundation
import os
import SwiftData
import SwiftUI

public class BabyActionService: ObservableObject {
    private let container: ModelContainer
    private let apiService: ApiService
    private let babyService: BabyService
    private let mappers: ActionMapperService

    init(_ container: ModelContainer, _ apiService: ApiService, _ babyService: BabyService, _ actionMapperService: ActionMapperService) {
        self.container = container
        self.apiService = apiService
        self.babyService = babyService
        self.mappers = actionMapperService
    }

    @discardableResult
    public func startAction(baby: Baby, type: BabyActionType) -> any Action {
        let mapper = mappers.getMapper(type: type)
        var action = mapper.create()

        action.baby = baby
        action.syncRequired = true
        action.action = type.rawValue
        action.start = Date()

        let taskAction = action
        Task {
            apiService.syncActionRemote(taskAction)
            await save(taskAction)
        }
        return action
    }

    public func endAction(_ action: any Action) {
        let action = action
        action.end = Date()
        action.syncRequired = true

        let taskAction = action
        Task {
            apiService.syncActionRemote(taskAction)
        }
    }

    public func insertOrUpdateAction(_ dto: any ActionDto, forBaby: Baby? = nil) async {
        let type = BabyActionType(rawValue: dto.type.lowercased())
        guard let actionType = type else {
            return
        }

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
            let newAction = mappers.getMapper(type: actionType).createFromDto(dto)
            newAction.baby = baby
            await save(newAction)
        }
    }

    public func getByRemoteId<ActionType: BabyAction>(_ id: Int64) async -> ActionType? {
        await MainActor.run {
            var descriptor = FetchDescriptor<ActionType>(predicate: #Predicate {
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

    public func save(_ action: any Action) async {
        await MainActor.run {
            self.container.mainContext.insert(action)
        }
    }
}
