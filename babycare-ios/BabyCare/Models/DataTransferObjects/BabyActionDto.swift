import Foundation
import os
import SwiftUI

public struct BabyActionDto: Decodable {
    var id: Int64
    var type: String
    var start: Date
    var end: Date?
}
