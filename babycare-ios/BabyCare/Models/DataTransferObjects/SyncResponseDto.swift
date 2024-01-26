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
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.syncedDate = try container.decode(Int.self, forKey: .syncedDate)

        var itemsArrayForType = try container.nestedUnkeyedContainer(forKey: .items)
        var items = [ActionDto]()

        var itemsArray = itemsArrayForType
        while !itemsArray.isAtEnd {
            let item = try itemsArrayForType.nestedContainer(keyedBy: DynamicCodingKeys.self)
            let type = try item.decode(String.self, forKey: DynamicCodingKeys(stringValue: "type")!)

            // TODO: Use custom decoder so it's possible to use the mapperservice to map each type instead of switch statement

            switch type {
            case "FEED":
                items.append(try itemsArray.decode(FeedActionDto.self))
            default:
                items.append(try itemsArray.decode(BabyActionDto.self))
            }
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
