import Foundation
import os
import SwiftUI

extension SleepAction: Action {
    public func update(source: ActionDto) {
        self.start = source.start
        self.end = source.end
        self.remoteId = source.id
        self.action = source.type.lowercased()
        self.night = (source as! SleepActionDto).night
    }
}

public extension SleepAction {
    convenience init(from: SleepActionDto) {
        self.init()
        self.update(source: from)
    }
}


