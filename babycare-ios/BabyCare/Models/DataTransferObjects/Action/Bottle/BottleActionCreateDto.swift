import Foundation
import os
import SwiftUI

public struct BottleActionCreateDto: ActionCreateDto {
    public var type: String
    public var start: Date
    public var end: Date?
    public var quantity: Int?

    init(from: BottleAction) {
        self.type = from.action?.uppercased(with: .autoupdatingCurrent) ?? ""
        self.start = from.start
        self.end = from.end
        self.quantity = from.quantity != nil ? Int(from.quantity!) : nil
    }
}
