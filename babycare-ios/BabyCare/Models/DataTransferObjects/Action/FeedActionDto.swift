import Foundation
import os
import SwiftUI

public struct FeedActionDto: ActionDto {
    public var id: Int64
    public var babyId: Int64
    public var type: String
    public var start: Date
    public var end: Date?
    public var side: String?
}

extension FeedActionDto {
    public static func decode(from decoder: Decoder) throws -> ActionDto {
        return try FeedActionDto(from: decoder)
    }
}
