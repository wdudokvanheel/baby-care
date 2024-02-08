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
    public func startAction<T: Action>(baby: Baby, type: BabyActionType) -> T {
        let action: T = createAction(baby: baby, type: type)
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

    public func deleteAction(_ action: any Action) {
        action.deleted = true
        action.syncRequired = true

        NotificationCenter.default.post(name: Notification.Name("update_\(action.action!)"), object: action)

        apiService.deleteAction(action) { action in
            print("Deleted action: \(action)")
            Task {
                await self.insertOrUpdateAction(action)
            }
        }
    }

    @discardableResult
    public func insertOrUpdateAction(_ dto: any ActionDto, forBaby: Baby? = nil) async -> UpdateStatus {
        let type = BabyActionType(rawValue: dto.type.lowercased())
        guard let actionType = type else {
            return UpdateStatus(.ERROR)
        }

        let mapper = mappers.getMapper(type: actionType)

        let action = await getByRemoteId(type: actionType, dto.id)

        if let deleted = dto.deleted, deleted {
            print("Action is already deleted; deleting local action if available (#\(dto.id))")
            if let action = action {
                print("Deleting action: \(action)")
                mapper.getService()?.onActionUpdate(action: action)
                await delete(action)
            }

            // Stop processing action if it's deleted
            return UpdateStatus(.DELETED)
        }

        var forBaby = forBaby

        if forBaby == nil {
            forBaby = await babyService.getByRemoteId(Int(dto.babyId))
        }

        guard let baby = forBaby else {
            return UpdateStatus(.ERROR)
        }

        var updateType: ACTION_SYNC_STATUS = .UPDATED

        NotificationCenter.default.post(name: Notification.Name("update_\(actionType)"), object: action)

        if let action = action {
            if action.end == nil, dto.end != nil {
                updateType = .ENDED
            }

            await MainActor.run {
                print("Updating action #\(dto.id)")
                action.baby = baby
                action.deleted = false
                action.syncRequired = false
                action.update(source: dto)

                mapper.getService()?.onActionUpdate(action: action)
            }
            return UpdateStatus(updateType, action)
        } else {
            print("Adding action #\(dto.id)")
            updateType = .STARTED
            let newAction = mappers.getMapper(type: actionType).createFromDto(dto)
            newAction.deleted = false
            newAction.syncRequired = false
            newAction.baby = baby
            await save(newAction)

            mapper.getService()?.onActionUpdate(action: newAction)

            return UpdateStatus(updateType, newAction)
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

    public func delete(_ action: any Action) async {
        await MainActor.run {
            self.container.mainContext.delete(action)
        }
    }
}

public struct UpdateStatus {
    let action: (any Action)?
    let status: ACTION_SYNC_STATUS

    init(_ status: ACTION_SYNC_STATUS, _ action: (any Action)? = nil) {
        self.action = action
        self.status = status
    }
}

public enum ACTION_SYNC_STATUS {
    case STARTED
    case ENDED
    case UPDATED
    case DELETED
    case ERROR
}
