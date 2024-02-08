import Foundation
import os
import SwiftUI

extension DailySleepDetails {
    var napsInt: Int {
        naps != nil ? Int(naps!) : 0
    }

    var sleepTimeDayInt: Int {
        sleepTimeDay != nil ? Int(sleepTimeDay!) : 0
    }

    var sleepTimeNightInt: Int {
        sleepTimeNight != nil ? Int(sleepTimeNight!) : 0
    }

    var sleepTimeTotal: Int {
        return sleepTimeDayInt + sleepTimeNightInt
    }
}

extension DailySleepDetails: CustomDebugStringConvertible {
    public var debugDescription: String {
        var description = "DailySleepDetails(id: \(id?.uuidString ?? "nil"), date: \(date), bedTime: \(String(describing: bedTime)), wakeTime: \(String(describing: wakeTime)), naps: \(String(describing: naps)), sleepTimeDay: \(String(describing: sleepTimeDay)), sleepTimeNight: \(String(describing: sleepTimeNight)))"
        return description
    }
}
