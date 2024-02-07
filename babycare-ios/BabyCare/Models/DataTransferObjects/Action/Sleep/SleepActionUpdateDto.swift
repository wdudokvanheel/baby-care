import Foundation
import SwiftUI
import os


public struct SleepActionUpdateDto: ActionUpdateDto {
    public var start: Date
    public var end: Date?
    public var night: Bool?

    init(from: SleepAction) {
        self.start = from.start
        self.end = from.end
        self.night = from.night
    }
}
