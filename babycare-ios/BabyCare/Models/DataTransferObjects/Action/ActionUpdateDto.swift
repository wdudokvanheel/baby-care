import Foundation
import os
import SwiftUI

public protocol ActionUpdateDto: Encodable {
    var start: Date { get set }
    var end: Date? { get set }
}
