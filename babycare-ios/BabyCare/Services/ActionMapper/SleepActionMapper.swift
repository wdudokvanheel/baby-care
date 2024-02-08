import Foundation
import SwiftData

public class SleepActionMapper: ActionMapper {
    private let services: ServiceContainer
    private lazy var service: SleepService = SleepService(services: services)

    public required init(_ services: ServiceContainer) {
        self.services = services
    }

    public func getService() -> (any ActionService)? {
        self.service
    }

    public func createFromDto(_ dto: ActionDto) -> SleepAction {
        return SleepAction(from: dto as! SleepActionDto)
    }

    public func toUpdateDto(_ action: any Action) -> ActionUpdateDto {
        SleepActionUpdateDto(from: action as! SleepAction)
    }

    public func toCreateDto(_ action: any Action) -> ActionCreateDto {
        SleepActionCreateDto(from: action as! SleepAction)
    }

    public func create() -> SleepAction {
        let action = SleepAction()
        return action
    }

    public func createFindByRemoteIdDescriptor(_ id: Int64) -> FetchDescriptor<SleepAction> {
        FetchDescriptor<SleepAction>(predicate: #Predicate {
            $0.remoteId == id
        })
    }

    public func createFindUnsyncedActionsDescriptor() -> FetchDescriptor<SleepAction> {
        FetchDescriptor<SleepAction>(predicate: #Predicate {
            $0.syncRequired ?? true
        })
    }

    public func getDtoType() -> SleepActionDto.Type {
        return SleepActionDto.self
    }
}
