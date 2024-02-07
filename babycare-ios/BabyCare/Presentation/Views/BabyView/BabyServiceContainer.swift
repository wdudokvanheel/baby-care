import Foundation
import os
import SwiftUI

public struct BabyServiceContainer {
    private var baby: Baby
    private var services: ServiceContainer
    lazy var sleepService = SleepService(container: services.container, baby: baby)
    lazy var feedService = FeedService(container: services.container, baby: baby)
    
    init(services: ServiceContainer, baby: Baby){
        self.baby = baby
        self.services = services
    }
}

