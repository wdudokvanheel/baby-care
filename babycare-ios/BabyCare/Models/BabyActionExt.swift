import Foundation
import os
import SwiftData
import SwiftUI

public enum BabyActionType: String, Codable, CaseIterable, Identifiable, Comparable {
    case none
    case feed
    case sleep
    case bottle

    public static func < (lhs: BabyActionType, rhs: BabyActionType) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    public var id: Self {
        return self
    }
}

extension BabyAction: Action {
    public func update(source: ActionDto) {
        self.start = source.start
        self.end = source.end
        self.remoteId = source.id
        self.action = source.type.lowercased()
    }
}

extension Action {
    var type: BabyActionType {
        get {
            BabyActionType(rawValue: self.action ?? BabyActionType.none.rawValue) ?? .none
        }
        set {
            self.action = newValue.rawValue
        }
    }

    var duration: TimeInterval {
        if let end = self.end {
            return end.timeIntervalSince(start)
        }
        else {
            return Date().timeIntervalSince(start)
        }
    }
}

extension BabyAction: CustomDebugStringConvertible {

    public var debugDescription: String {
        return """
        BabyAction:
            ID: \(id?.uuidString ?? "nil"),
            Action: \(action ?? "nil"),
            Start: \(start.description),
            End: \(end?.description ?? "nil"),
            Remote ID: \(remoteId ?? 0),
            Sync Required: \(syncRequired.map { $0 ? "Yes" : "No" } ?? "nil")
        """
    }
}

public extension BabyAction {
    convenience init(from: BabyActionDto) {
        self.init()
        self.update(source: from)
    }
}
