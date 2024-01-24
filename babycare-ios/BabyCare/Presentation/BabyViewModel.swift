import Foundation
import os
import SwiftUI

public class BabyViewModel {
    private var baby: Baby

    init(services: BabyCareServiceContainer, baby: Baby) {
        self.baby = baby
    }
}
