import Foundation
import SwiftData

@Model public class FeedAction {
    public var action: String?
    public var deleted: Bool?
    public var end: Date?
    public var id: UUID?
    public var remoteId: Int64? = 0
    public var start: Date?
    public var syncRequired: Bool?
    public var side: String?
    public var baby: Baby?
    public init() {}
}
