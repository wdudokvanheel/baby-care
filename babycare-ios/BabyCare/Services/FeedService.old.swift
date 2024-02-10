//import Foundation
//import SwiftData
//import SwiftUI
//
//class FeedService: ObservableObject {
//    @Published
//    public var detailsToday: DayFeedDetailsModel
//
//    private let baby: Baby
//    private let container: ModelContainer
//    private var timer: Timer?
//
//    init(container: ModelContainer, baby: Baby) {
//        self.container = container
//        self.baby = baby
//
//        detailsToday = DayFeedDetailsModel()
//
//        updateTodayDetails()
//
//        NotificationCenter.default.addObserver(self, selector: #selector(updateTodayDetails), name: Notification.Name("update_feed"), object: nil)
//
//        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
//            self?.updateTodayDetails()
//        }
//    }
//
//    @objc func updateTodayDetails() {
//        Task {
//            let details = await getFeedDetails(Date())
//            DispatchQueue.main.async {
//                self.detailsToday = details
//            }
//        }
//    }
//
//    func getFeedDetails(_ date: Date) async -> DayFeedDetailsModel {
//        var model = DayFeedDetailsModel()
//        let actions = await getActionsForDate(date)
//
//        for action in actions {
//            model.feedingTimeTotal += Int(action.duration)
//            if let side = action.feedSide {
//                switch side {
//                    case .left:
//                        model.feedingTimeLeft += Int(action.duration)
//                    case .right:
//                        model.feedingTimeRight += Int(action.duration)
//                }
//            }
//        }
//        model.lastFeed = actions.last
//
//        return model
//    }
//
//    private func getActionsForDate(_ date: Date) async -> [FeedAction] {
//        let startDate = Calendar.current.startOfDay(for: date)
//        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
//
//        return await MainActor.run {
//            let babyId = self.baby.persistentModelID
//            let descriptor = FetchDescriptor<FeedAction>(predicate: #Predicate { sleep in
//                sleep.baby?.persistentModelID == babyId &&
//                    sleep.start >= startDate &&
//                    sleep.start <= endDate &&
//                    sleep.deleted != true
//            }, sortBy: [SortDescriptor<FeedAction>(\.start)])
//            do {
//                let result = try container.mainContext.fetch(descriptor)
//                if result.count > 0 {
//                    return result
//                }
//            } catch {
//                print("Error \(error)")
//            }
//
//            return []
//        }
//    }
//
//    deinit {
//        timer?.invalidate()
//    }
//}
//
//struct DayFeedDetailsModel {
//    var lastFeed: FeedAction?
//    var feedingTimeLeft: Int = 0
//    var feedingTimeRight: Int = 0
//    var feedingTimeTotal: Int = 0
//}
