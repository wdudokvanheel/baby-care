import Foundation
import os
import SwiftUI

public struct SleepActionCreateDto: ActionCreateDto {
    public var type: String
    public var start: Date
    public var end: Date?
    public var night: Bool?

    init(from: SleepAction) {
        self.type = from.action?.uppercased(with: .autoupdatingCurrent) ?? ""
        self.start = from.start
        self.end = from.end
        self.night = from.night
    }
}
