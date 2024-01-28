import Foundation
import os
import SwiftUI

public class BabyViewModel: ObservableObject {
    @Published
    public var baby: Baby
    private let actionService: BabyActionService

    init(services: BabyCareServiceContainer, baby: Baby) {
        self.baby = baby
        self.actionService = services.actionService
    }

    func startSleep() {
        actionService.startAction(baby: baby, type: .sleep)
    }

    func stopSleep(_ action: BabyAction) {
        actionService.endAction(action)
    }

    func startFeed(_ side: FeedSide? = nil) {
        let action: FeedAction = actionService.createAction(baby: baby, type: .feed)
        action.feedSide = side
        actionService.persistAction(action)
    }

    func setFeedSide(_ action: FeedAction, _ side: FeedSide? = nil) {
        action.feedSide = side
        actionService.persistAction(action)
    }

    func stopFeed(_ action: FeedAction) {
        actionService.endAction(action)
    }
}
