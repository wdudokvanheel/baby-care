import Foundation
import os
import SwiftUI

extension FeedAction: Action {
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

public enum FeedSide: String, Codable, CaseIterable, Identifiable, Comparable, CustomDebugStringConvertible {
    case left
    case right

    public static func < (lhs: FeedSide, rhs: FeedSide) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    public var id: Self {
        return self
    }

    public var debugDescription: String {
        switch self {
        case .left:
            return "left"
        case .right:
            return "right"
        }
    }
}

extension FeedAction {
    var feedSide: FeedSide? {
        get {
            side != nil ? FeedSide(rawValue: self.side!.lowercased()) : nil
        }
        set {
            self.side = newValue?.rawValue.uppercased() ?? nil
        }
    }
}
