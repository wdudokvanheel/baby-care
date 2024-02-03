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

    func startBottle(_ quantity: Int64? = nil) {
        let action: BottleAction = actionService.createAction(baby: baby, type: .bottle)
        if let quantity = quantity {
            action.quantity = quantity
        }
        actionService.persistAction(action)
    }

    func stopBottle(_ action: BottleAction) {
        actionService.endAction(action)
    }

    func setFeedSide(_ action: FeedAction, _ side: FeedSide? = nil) {
        action.feedSide = side
        actionService.persistAction(action)
    }

    func stopFeed(_ action: FeedAction) {
        actionService.endAction(action)
    }

    func updateAction(_ action: any Action) {
        action.syncRequired = true
        actionService.persistAction(action)
    }
    
    func deleteAction(_ action: any Action) {
        actionService.deleteAction(action)
    }
}
