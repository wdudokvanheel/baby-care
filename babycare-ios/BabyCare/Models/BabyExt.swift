import Foundation
import os
import SwiftUI

public extension Baby {
    convenience init(from: BabyDto) {
        self.init()
        self.update(source: from)
    }

    func update(source: BabyDto) {
        self.remoteId = Int64(source.id)
        self.name = source.name
        self.birthDate = source.birthDate
    }
}
