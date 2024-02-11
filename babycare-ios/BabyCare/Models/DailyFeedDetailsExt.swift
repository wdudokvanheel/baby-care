import Foundation
import os
import SwiftUI

extension DailyFeedDetails {
    var leftInt: Int {
        Int(left ?? 0)
    }

    var rightInt: Int {
        Int(right ?? 0)
    }

    var totalInt: Int {
        Int(total ?? 0)
    }

    var leftPercentage: Int {
        guard let left = left, let total = total, total > 0 else {
            return 0
        }
        return Int((Float(left) / Float(total)) * 100)
    }

    var rightPercentage: Int {
        guard let right = right, let total = total, total > 0 else {
            return 0
        }
        return Int((Float(right) / Float(total)) * 100)
    }
}
