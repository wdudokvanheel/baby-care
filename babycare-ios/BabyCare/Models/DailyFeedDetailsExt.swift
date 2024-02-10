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
}
