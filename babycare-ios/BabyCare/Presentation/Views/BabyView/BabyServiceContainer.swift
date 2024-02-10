import Foundation
import os
import SwiftUI

public struct BabyServiceContainer {
    private var baby: Baby
    private var services: ServiceContainer
    
    init(services: ServiceContainer, baby: Baby){
        self.baby = baby
        self.services = services
    }
}

