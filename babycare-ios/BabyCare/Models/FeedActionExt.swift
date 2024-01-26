import Foundation
import SwiftUI
import os


extension FeedAction: Action{
    public func update(source: ActionDto) {
        self.start = source.start
        self.end = source.end
        self.remoteId = source.id
        self.action = source.type.lowercased()
        self.side = (source as! FeedActionDto).side
    }
}

public extension FeedAction {
    convenience init(from: FeedActionDto) {
        self.init()
        self.update(source: from)
    }
}
