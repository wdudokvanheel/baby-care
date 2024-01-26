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
    
    func stopSleep(_ action: BabyAction){
        actionService.endAction(action)
    }
    
    func startFeed() {
        actionService.startAction(baby: baby, type: .feed)
    }
    
    func stopFeed(_ action: FeedAction){
        action.side = "RIGHT"
        actionService.endAction(action)
    }
}
