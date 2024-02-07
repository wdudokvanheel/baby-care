import Foundation
import SwiftUI

public class BabyActionUpdateDto: ActionUpdateDto {
    public var start: Date
    public var end: Date?

    init(start: Date, end: Date) {
        self.start = start
        self.end = end
    }

    init(from: BabyAction) {
        self.start = from.start
        self.end = from.end
    }
}
