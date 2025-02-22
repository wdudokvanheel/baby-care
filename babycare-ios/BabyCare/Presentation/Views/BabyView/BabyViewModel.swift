import Foundation
import os
import SwiftUI

public class BabyViewModel: ObservableObject {
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

    func updateAction(_ action: any Action) {
        action.syncRequired = true
        actionService.persistAction(action)
    }

    func deleteAction(_ action: any Action) {
        actionService.deleteAction(action)
    }
}
