import Foundation
import SwiftData

@Model public class SleepAction {
    public var action: String?
    public var deleted: Bool = false
    public var end: Date?
    public var id: UUID?
    public var remoteId: Int64? = 0
    public var start: Date = Date()
    public var syncRequired: Bool?
    public var night: Bool?
    public var baby: Baby?

    init() {}
}
