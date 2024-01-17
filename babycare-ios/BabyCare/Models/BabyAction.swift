import Foundation
import SwiftData

@Model
public class BabyAction {
    var action: String?
    var end: Date?
    public var id: UUID?
    var start: Date?
    var syncRequired: Bool = true

    public init() {}
}

public enum BabyActionType: String, Codable {
    case none
    case feed
    case sleep
}

extension BabyAction {
    var type: BabyActionType {
        get {
            BabyActionType(rawValue: self.action ?? BabyActionType.none.rawValue) ?? .none
        }
        set {
            self.action = newValue.rawValue
        }
    }
}
