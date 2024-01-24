import Foundation
import os
import SwiftUI

public struct BabyDto: Decodable {
    var id: Int
    var name: String
    var birthDate: Date
}
