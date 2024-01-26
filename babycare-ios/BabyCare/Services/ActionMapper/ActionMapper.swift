public protocol ActionMapper {
    associatedtype ActionType: Action

    func create() -> ActionType
    func createFromDto(_ dto: any ActionDto) -> ActionType
    func toUpdateDto(_ action: any Action) -> any ActionUpdateDto
    func toCreateDto(_ action: any Action) -> any ActionCreateDto
}
