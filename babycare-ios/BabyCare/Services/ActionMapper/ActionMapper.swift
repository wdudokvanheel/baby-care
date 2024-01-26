import Foundation
import SwiftData

public protocol ActionMapper {
    associatedtype ActionType: Action
    associatedtype ActionDtoType: ActionDto
    
    func getDtoType() -> ActionDtoType.Type
    
    func create() -> ActionType
    func createFromDto(_ dto: any ActionDto) -> ActionType
    func toUpdateDto(_ action: any Action) -> any ActionUpdateDto
    func toCreateDto(_ action: any Action) -> any ActionCreateDto
    func createFindByRemoteIdDescriptor(_ id: Int64) -> FetchDescriptor<ActionType>
}
