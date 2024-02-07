import Foundation
import os
import SwiftUI

public class BabyViewModel: ObservableObject {
    @Published
    public var baby: Baby
    public var services: ServiceContainer
    public var babyServices: BabyServiceContainer
    private let actionService: BabyActionService

    init(services: ServiceContainer, baby: Baby) {
        self.baby = baby
        self.services = services
        self.babyServices = BabyServiceContainer(services: services, baby: baby)
        self.actionService = services.actionService
    }

    // TODO: Move these functions to services for each action
    func startSleep() {
        let action: SleepAction = actionService.createAction(baby: baby, type: .sleep)

        let hour = Calendar.current.component(.hour, from: Date())
        action.night = hour >= BabyCareApp.nightStartHour || hour < BabyCareApp.nightEndHour
        
        actionService.persistAction(action)
    }

    func stopSleep(_ action: SleepAction) {
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
