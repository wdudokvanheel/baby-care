import Foundation
import os
import SwiftUI

public struct BottleActionDto: ActionDto {
    public var id: Int64
    public var babyId: Int64
    public var type: String
    public var start: Date
    public var end: Date?
    public var quantity: Int?
}

public extension BottleActionDto {
    static func decode(from decoder: Decoder) throws -> ActionDto {
        return try BottleActionDto(from: decoder)
    }
}
