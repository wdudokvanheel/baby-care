import Foundation
import SwiftData


@Model public class BabyAction {
    var action: String?
    var end: Date?
    public var id: UUID?
    var remoteId: Int64? = 0
    var start: Date?
    var syncRequired: Bool?
    public init() {

    }
    
}
