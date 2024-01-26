import Foundation
import os
import SwiftUI
import SwiftData

public protocol Action : PersistentModel {
    var action: String? { get set }
    var end: Date? { get set }
    var id: UUID? { get set }
    var remoteId: Int64? { get set }
    var start: Date? { get set }
    var syncRequired: Bool? { get set }
    var baby: Baby? { get set }
    
    func update(source: any ActionDto)
}
