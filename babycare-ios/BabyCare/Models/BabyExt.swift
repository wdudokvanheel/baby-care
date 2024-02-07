import Foundation
import os
import SwiftUI

public extension Baby {
    convenience init(from: BabyDto) {
        self.init()
        self.update(source: from)
    }

    func update(source: BabyDto) {
        self.remoteId = Int64(source.id)
        self.name = source.name
        self.birthDate = source.birthDate
    }

    var displayName: String {
        return name ?? "Unnamed Baby"
    }
}

extension Baby: Equatable {
    public static func == (lhs: Baby, rhs: Baby) -> Bool {
        return lhs.persistentModelID == rhs.persistentModelID
    }
}
