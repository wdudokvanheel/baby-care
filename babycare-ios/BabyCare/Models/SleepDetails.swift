import Foundation
import SwiftData

@Model
public class DailySleepDetails {
    var date: Date
    var baby: Baby?
    public var id: UUID?
    var bedTime: Date?
    var wakeTime: Date?
    var naps: Int16? = 0
    var sleepTimeDay: Int32? = 0
    var sleepTimeNight: Int32? = 0

    init(date: Date) {
        self.date = date
    }
}
