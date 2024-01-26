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
            switch type {
            case "FEED":
                print("GOOT FGEEEED!!!")
                items.append(try itemsArray.decode(FeedActionDto.self))
            default:
                print("GOOT LAME ASS SHIZZL")
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
