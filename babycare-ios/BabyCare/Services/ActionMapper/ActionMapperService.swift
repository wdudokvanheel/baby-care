import Foundation

public class ActionMapperService: ObservableObject {
    @Published
    private(set) var mappers: [BabyActionType: any ActionMapper] = [:]
    @Published
    private(set) var defaultMapper: any ActionMapper = DefaultActionMapper()

    init() {
        mappers[.feed] = FeedActionMapper()
    }
    
    public var all: [any ActionMapper] {
        var all: [any ActionMapper] = Array(mappers.values)
        all.append(defaultMapper)
        return all
    }

    public func getMapper(type: BabyActionType) -> (any ActionMapper) {
        return mappers[type] ?? defaultMapper
    }
}
