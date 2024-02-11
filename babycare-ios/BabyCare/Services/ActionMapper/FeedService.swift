import Foundation
import SwiftData
import SwiftUI

class FeedService: ActionService {
    typealias ActionType = FeedAction

    private let container: ModelContainer
    private let actionService: BabyActionService

    init(services: ServiceContainer) {
        self.container = services.container
        self.actionService = services.actionService
    }

    @discardableResult
    func start(_ baby: Baby) -> any Action {
        let action: FeedAction = actionService.createAction(baby: baby, type: .feed)
        actionService.persistAction(action)
        return action
    }

    @discardableResult
    func start(_ baby: Baby, _ side: FeedSide?) -> FeedAction {
        let action: FeedAction = actionService.createAction(baby: baby, type: .feed)
        action.feedSide = side
        actionService.persistAction(action)
        return action
    }

    func stop(_ action: any Action) {
        actionService.endAction(action)
        onActionUpdate(action)
    }

    func update(_ action: any Action) {
        action.syncRequired = true
        actionService.persistAction(action)
        onActionUpdate(action)
    }

    func setFeedSide(_ action: FeedAction, _ side: FeedSide? = nil) {
        action.feedSide = side
        update(action)
    }

    func onActionUpdate(_ action: any Action) {
        print("Update details for feed action #\(action.remoteId ?? 0)")
        let date = action.start
        if let baby = action.baby {
            Task {
                await updateDetails(date, baby)
            }
        }
    }

    func delete(_ action: any Action) {
        onActionUpdate(action)
        actionService.deleteAction(action)
    }

    func createQueryByDate(_ baby: Baby, _ date: Date) -> Query<FeedAction, [FeedAction]> {
        let babyId = baby.persistentModelID
        let type = BabyActionType.feed.rawValue

        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!

        let filter = #Predicate<FeedAction> { action in
            action.end != nil &&
                action.action == type &&
                action.deleted == false &&
                action.baby?.persistentModelID == babyId &&
                action.start > start &&
                action.start < end
        }

        let fetchDescriptor = FetchDescriptor<FeedAction>(predicate: filter, sortBy: [SortDescriptor<FeedAction>(\.end, order: .reverse)])
        return Query(fetchDescriptor)
    }

    static func createQueryDetailsByDate(_ date: Date, _ baby: Baby) -> Query<DailyFeedDetails, [DailyFeedDetails]> {
        let date = Calendar.current.startOfDay(for: date)
        let babyId = baby.persistentModelID

        let filter = #Predicate<DailyFeedDetails> { details in
            details.baby?.persistentModelID == babyId &&
                details.date == date
        }

        var fetchDescriptor = FetchDescriptor<DailyFeedDetails>(predicate: filter)
        fetchDescriptor.fetchLimit = 1
        return Query(fetchDescriptor)
    }

    public func updateDetails(_ date: Date, _ baby: Baby) async {
        let date = Calendar.current.startOfDay(for: date)

        var insert = false
        var model: DailyFeedDetails

        if let details = await getDetailsStorage(date, baby) {
            model = details
        } else {
            insert = true
            model = DailyFeedDetails(date: date)
            let m = model
            await MainActor.run {
                m.baby = baby
            }
        }

        await updateModel(model)

        if insert {
            let model = model
            await MainActor.run {
                container.mainContext.insert(model)
            }
        }
    }

    private func updateModel(_ model: DailyFeedDetails) async {
        guard let baby = model.baby else {
            return
        }
        let date = model.date
        let actions = await getActionsForDate(date, baby)
        
        await MainActor.run {
            let actionsWithSide = actions.filter { $0.feedSide != nil }

            model.left = Int32(actionsWithSide.filter { $0.feedSide == .left }.duration)
            model.right = Int32(actionsWithSide.filter { $0.feedSide == .right }.duration)
            model.total = Int32(actions.duration)
        }
    }

    private func getDetailsStorage(_ date: Date, _ baby: Baby) async -> DailyFeedDetails? {
        await MainActor.run {
            let babyId = baby.persistentModelID

            let descriptor = FetchDescriptor<DailyFeedDetails>(predicate: #Predicate { day in
                day.baby?.persistentModelID == babyId &&
                    day.date == date
            })

            do {
                let result = try container.mainContext.fetch(descriptor)
                if result.count > 0 {
                    return result[0]
                }
            } catch {
                print("Error \(error)")
            }

            return nil
        }
    }

    private func getActionsForDate(_ date: Date, _ baby: Baby) async -> [FeedAction] {
        let startDate = Calendar.current.startOfDay(for: date)
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!

        return await MainActor.run {
            let babyId = baby.persistentModelID
            let descriptor = FetchDescriptor<FeedAction>(predicate: #Predicate { sleep in
                sleep.baby?.persistentModelID == babyId &&
                    sleep.start >= startDate &&
                    sleep.start <= endDate &&
                    sleep.deleted != true
            }, sortBy: [SortDescriptor<FeedAction>(\.start)])
            do {
                let result = try container.mainContext.fetch(descriptor)
                if result.count > 0 {
                    return result
                }
            } catch {
                print("Error \(error)")
            }

            return []
        }
    }

    func createDetailsIfUnavailable(_ date: Date, baby: Baby) {
        Task {
            let date = Calendar.current.startOfDay(for: date)

            if await getDetailsStorage(date, baby) != nil {
                return
            }
            let model = DailyFeedDetails(date: date)

            await MainActor.run {
                model.baby = baby
            }
            await updateModel(model)

            let updateModel = model
            await MainActor.run {
                container.mainContext.insert(updateModel)
            }
        }
    }
}

extension Array where Element == FeedAction {
    var duration: Int {
        return Int(reduce(0) { $0 + $1.duration })
    }
}
