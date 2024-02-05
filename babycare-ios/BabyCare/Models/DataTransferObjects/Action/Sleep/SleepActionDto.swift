import Foundation
import os
import SwiftUI

public struct SleepActionDto: ActionDto {
    public var id: Int64
    public var babyId: Int64
    public var type: String
    public var deleted: Bool?
    public var start: Date
    public var end: Date?
    public var night: Bool?
}

public extension SleepActionDto {
    static func decode(from decoder: Decoder) throws -> ActionDto {
        return try SleepActionDto(from: decoder)
    }
}
