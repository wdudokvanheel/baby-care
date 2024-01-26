import Foundation
import os
import SwiftUI

public protocol ActionCreateDto: Encodable {
    var type: String { get set }
    var start: Date { get set }
    var end: Date? { get set }
}
