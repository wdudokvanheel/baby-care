import Foundation
import os
import SwiftUI

public struct FeedActionUpdateDto: ActionUpdateDto {
    public var start: Date
    public var end: Date?
    public var side: String?

    init(from: FeedAction) {
        self.start = from.start ?? Date()
        self.end = from.end
        self.side = from.side
    }
}
