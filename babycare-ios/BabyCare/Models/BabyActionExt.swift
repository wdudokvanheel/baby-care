import Foundation
import os
import SwiftData
import SwiftUI

public enum BabyActionType: String, Codable {
    case none
    case feed
    case sleep
}

extension BabyAction: CustomDebugStringConvertible {
    var type: BabyActionType {
        get {
            BabyActionType(rawValue: self.action ?? BabyActionType.none.rawValue) ?? .none
        }
        set {
            self.action = newValue.rawValue
        }
    }

    public var debugDescription: String {
        return """
        BabyAction:
            ID: \(id?.uuidString ?? "nil"),
            Action: \(action ?? "nil"),
            Start: \(start?.description ?? "nil"),
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

    func update(source: BabyActionDto) {
        self.start = source.start
        self.end = source.end
        self.remoteId = source.id
        self.action = source.type.lowercased()
    }
}
