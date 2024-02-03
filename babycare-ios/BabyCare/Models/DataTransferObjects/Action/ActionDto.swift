import Foundation
import os
import SwiftUI

public protocol ActionDto: Decodable {
    var id: Int64 { get set }
    var babyId: Int64 { get set }
    var type: String { get set }
    var deleted: Bool? { get set }
    var start: Date { get set }
    var end: Date? { get set }
    
    static func decode(from decoder: Decoder) throws -> ActionDto
}
