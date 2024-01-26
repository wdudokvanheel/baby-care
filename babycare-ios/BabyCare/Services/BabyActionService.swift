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
        let action: BabyAction = createAction(baby: baby, type: type)
        persistAction(action)
        return action
    }

    public func persistAction(_ action: any Action) {
        Task {
            apiService.syncActionRemote(action)
            await save(action)
        }
    }

    public func createAction<T: Action>(baby: Baby, type: BabyActionType) -> T {
        let mapper = mappers.getMapper(type: type)
        let action = mapper.create()

        action.baby = baby
        action.syncRequired = true
        action.action = type.rawValue
        action.start = Date()
        return action as! T
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

        let action = await getByRemoteId(type: actionType, dto.id)
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

    public func getByRemoteId(type: BabyActionType, _ id: Int64) async -> (any Action)? {
        let mapper = mappers.getMapper(type: type)
        return await findByIdWithMapper(mapper, id)
    }

    private func findByIdWithMapper<Mapper: ActionMapper>(_ mapper: Mapper, _ id: Int64) async -> (any Action)? {
        await MainActor.run {
            let descriptor = mapper.createFindByRemoteIdDescriptor(id)
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

    public func getUnsavedActions() async -> [any Action] {
        var actions: [any Action] = []
        for mapper in mappers.all {
            actions.append(contentsOf: await getUnsavedActions(from: mapper))
        }
        return actions
    }

    private func getUnsavedActions<Mapper: ActionMapper>(from: Mapper) async -> [any Action] {
        await MainActor.run {
            let descriptor = from.createFindUnsyncedActionsDescriptor()
            do {
                let result = try self.container.mainContext.fetch(descriptor)
                return result
            } catch {
                print("Error getting unsaved actions \(error)")
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
