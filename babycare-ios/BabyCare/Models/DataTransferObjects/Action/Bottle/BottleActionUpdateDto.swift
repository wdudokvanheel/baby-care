import Foundation
import os
import SwiftUI

import Foundation
import os
import SwiftUI

public struct BottleActionUpdateDto: ActionUpdateDto {
    public var start: Date
    public var end: Date?
    public var quantity: Int?

    init(from: BottleAction) {
        self.start = from.start
        self.end = from.end
        self.quantity = from.quantity != nil ? Int(from.quantity!) : nil
    }
}
