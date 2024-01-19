import Foundation
import os
import SwiftUI

public class BabyActionCreateDto: Encodable {
    public var type: String
    public var start: Date
    public var end: Date?

    init(type: String, start: Date, end: Date) {
        self.type = type
        self.start = start
        self.end = end
    }

    init(from: BabyAction) {
        self.type = from.action?.uppercased(with: .autoupdatingCurrent) ?? ""
        self.start = from.start ?? Date()
        self.end = from.end
    }

    enum CodingKeys: String, CodingKey {
        case type, start, end
    }
}
