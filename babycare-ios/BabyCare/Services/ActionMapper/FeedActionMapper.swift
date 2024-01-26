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
    
 
}
