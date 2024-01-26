public class DefaultActionMapper: ActionMapper {
    public func createFromDto(_ dto: ActionDto) -> BabyAction {
        BabyAction(from: dto as! BabyActionDto)
    }
    
    public func toUpdateDto(_ action: any Action) -> ActionUpdateDto {
        BabyActionUpdateDto(from: action as! BabyAction)
    }

    public func toCreateDto(_ action: any Action) -> ActionCreateDto {
        BabyActionCreateDto(from: action as! BabyAction)
    }

    public func create() -> BabyAction {
        return BabyAction()
    }
}
