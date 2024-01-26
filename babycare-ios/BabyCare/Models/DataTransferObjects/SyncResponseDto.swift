import Foundation
import os
import SwiftUI

public struct SyncResponseDto<Type: Decodable>: Decodable {
    public let items: [Type]
    public let syncedDate: Int
}

public struct ActionSyncResponse {
    public let items: [any ActionDto]
    public let syncedDate: Int
}

extension ActionSyncResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case items, syncedDate
    }

    public init(from decoder: Decoder) throws {
        // TODO: Create customer decoder and inject ActionMapperService instead of creating a new one here
        let mappers = ActionMapperService()

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.syncedDate = try container.decode(Int.self, forKey: .syncedDate)

        var itemsArrayForType = try container.nestedUnkeyedContainer(forKey: .items)
        var items = [ActionDto]()

        var itemsArray = itemsArrayForType
        while !itemsArray.isAtEnd {
            let item = try itemsArrayForType.nestedContainer(keyedBy: DynamicCodingKeys.self)
            let type = try item.decode(String.self, forKey: DynamicCodingKeys(stringValue: "type")!)
            let mapper = mappers.getMapper(type: BabyActionType(rawValue: type.lowercased())!)
            items.append(try itemsArray.decode(mapper.getDtoType()))
        }

        self.items = items
    }
}

private struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    var intValue: Int?
    init?(intValue: Int) {
        return nil
    }
}
