import Foundation
import SwiftData

public class FeedActionMapper: ActionMapper {
    public func createFromDto(_ dto: ActionDto) -> FeedAction {
        return FeedAction(from: dto as! FeedActionDto)
    }

    public func toUpdateDto(_ action: any Action) -> ActionUpdateDto {
        FeedActionUpdateDto(from: action as! FeedAction)
    }

    public func toCreateDto(_ action: any Action) -> ActionCreateDto {
        FeedActionCreateDto(from: action as! FeedAction)
    }

    public func create() -> FeedAction {
        let action = FeedAction()
        return action
    }

    public func createFindByRemoteIdDescriptor(_ id: Int64) -> FetchDescriptor<FeedAction> {
        FetchDescriptor<FeedAction>(predicate: #Predicate {
            $0.remoteId == id
        })
    }

    public func createFindUnsyncedActionsDescriptor() -> FetchDescriptor<FeedAction> {
        FetchDescriptor<FeedAction>(predicate: #Predicate {
            $0.syncRequired ?? true
        })
    }

    public func getDtoType() -> FeedActionDto.Type {
        return FeedActionDto.self
    }
}
