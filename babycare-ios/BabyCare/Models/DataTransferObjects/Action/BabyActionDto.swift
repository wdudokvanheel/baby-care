import Foundation
import os
import SwiftUI

public struct BabyActionDto: ActionDto {
    public var id: Int64
    public var babyId: Int64
    public var type: String
    public var deleted: Bool?
    public var start: Date
    public var end: Date?
}

extension BabyActionDto {
    public static func decode(from decoder: Decoder) throws -> ActionDto {
        return try BabyActionDto(from: decoder)
    }
}
