import Foundation

public class ActionMapperService: ObservableObject {
    @Published private(set) var mappers: [BabyActionType: any ActionMapper] = [:]
    @Published private(set) var defaultMapper: any ActionMapper

    init(services: ServiceContainer) {
        defaultMapper = DefaultActionMapper(services)
        mappers[.sleep] = SleepActionMapper(services)
        mappers[.feed] = FeedActionMapper(services)
        mappers[.bottle] = BottleActionMapper(services)
    }

    public var all: [any ActionMapper] {
        var all: [any ActionMapper] = Array(mappers.values)
        all.append(defaultMapper)
        return all
    }

    public func getMapper(type: BabyActionType) -> (any ActionMapper) {
        return mappers[type] ?? defaultMapper
    }

    public func getService<T: ActionService>(type: BabyActionType) -> T {
        getMapper(type: type).getService()! as! T
    }
}
