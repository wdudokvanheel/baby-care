import Foundation
import SwiftUI

public class BabyActionUpdateDto: Encodable {
    public var start: Date
    public var end: Date?

    init(start: Date, end: Date) {
        self.start = start
        self.end = end
    }

    init(from: BabyAction) {
        self.start = from.start ?? Date()
        self.end = from.end
    }
}
