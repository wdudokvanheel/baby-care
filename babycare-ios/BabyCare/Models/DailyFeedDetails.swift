import Foundation
import SwiftData

@Model
public class DailyFeedDetails {
    var date: Date
    public var id: UUID?
    var left: Int32? = 0
    var right: Int32? = 0
    var total: Int32? = 0
    var baby: Baby?

    init(date: Date) {
        self.date = date
    }
}
