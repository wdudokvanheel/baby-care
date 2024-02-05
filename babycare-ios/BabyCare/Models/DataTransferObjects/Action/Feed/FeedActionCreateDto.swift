import Foundation
import os
import SwiftUI

public struct FeedActionCreateDto: ActionCreateDto {
    public var type: String
    public var start: Date
    public var end: Date?
    public var side: String?

    init(from: FeedAction) {
        self.type = from.action?.uppercased(with: .autoupdatingCurrent) ?? ""
        self.start = from.start ?? Date()
        self.end = from.end
        self.side = from.side
    }
}
