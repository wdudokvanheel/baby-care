import Foundation
import SwiftData

public class FeedActionMapper: ActionMapper {
    private let services: ServiceContainer
    private lazy var service: FeedService = FeedService(services: services)

    public required init(_ services: ServiceContainer) {
        self.services = services
    }

    public func getService() -> (any ActionService)? {
        self.service
    }

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
