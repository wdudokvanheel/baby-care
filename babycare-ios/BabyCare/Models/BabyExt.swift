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

extension Baby: CustomDebugStringConvertible {
    public var debugDescription: String {
        var description = "Baby: \n"
        description += "id: \(id.uuidString ?? "nil"), \n"
        description += "name: \(name ?? "nil"), \n"
        description += "birthDate: \(birthDate), \n"
        description += "remoteId: \(String(describing: remoteId)), \n"
        description += "lastSync: \(String(describing: lastSync))\n"
        return description
    }
}
