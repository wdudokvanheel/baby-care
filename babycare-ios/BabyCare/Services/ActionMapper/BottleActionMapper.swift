import Foundation
import SwiftData

public class BottleActionMapper: ActionMapper {
    public required init(_ services: ServiceContainer) {}

//
//    public func getService() -> any ActionService {
//        service
//    }
    public func getService() -> (any ActionService)? {
        nil
    }
    public func createFromDto(_ dto: ActionDto) -> BottleAction {
        return BottleAction(from: dto as! BottleActionDto)
    }

    public func toUpdateDto(_ action: any Action) -> ActionUpdateDto {
        BottleActionUpdateDto(from: action as! BottleAction)
    }

    public func toCreateDto(_ action: any Action) -> ActionCreateDto {
        BottleActionCreateDto(from: action as! BottleAction)
    }

    public func create() -> BottleAction {
        let action = BottleAction()
        return action
    }

    public func createFindByRemoteIdDescriptor(_ id: Int64) -> FetchDescriptor<BottleAction> {
        FetchDescriptor<BottleAction>(predicate: #Predicate {
            $0.remoteId == id
        })
    }

    public func createFindUnsyncedActionsDescriptor() -> FetchDescriptor<BottleAction> {
        FetchDescriptor<BottleAction>(predicate: #Predicate {
            $0.syncRequired ?? true
        })
    }

    public func getDtoType() -> BottleActionDto.Type {
        return BottleActionDto.self
    }
}
