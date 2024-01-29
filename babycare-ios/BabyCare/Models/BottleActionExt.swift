import Foundation
import os
import SwiftUI

extension BottleAction: Action {
    public func update(source: ActionDto) {
        self.start = source.start
        self.end = source.end
        self.remoteId = source.id
        self.action = source.type.lowercased()
        let source = source as! BottleActionDto
        self.quantity = source.quantity != nil ? Int64(source.quantity!) : nil
    }
}

public extension BottleAction {
    convenience init(from: BottleActionDto) {
        self.init()
        self.update(source: from)
    }
}
