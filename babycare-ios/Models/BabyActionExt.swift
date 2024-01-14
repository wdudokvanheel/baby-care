import Foundation
import SwiftUI
import os

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
