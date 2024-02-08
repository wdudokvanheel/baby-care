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
        guard let services = decoder.userInfo[.serviceContainer] as? ServiceContainer else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Missing service"))
        }

        let mappers = services.actionMapperService

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

extension CodingUserInfoKey {
    // Define a key for your service
    static let serviceContainer = CodingUserInfoKey(rawValue: "serviceContainer")!
}

// class CustomDecoder: Decoder {
//    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
//        try underlyingDecoder.unkeyedContainer()
//    }
//
//    func singleValueContainer() throws -> SingleValueDecodingContainer {
//        try underlyingDecoder.singleValueContainer()
//    }
//
//    let service: ServiceContainer
//    private let underlyingDecoder: Decoder
//
//    init(service: ServiceContainer, underlyingDecoder: Decoder) {
//        self.service = service
//        self.underlyingDecoder = underlyingDecoder
//    }
//
//    // Implement all required properties and methods by forwarding them to the underlyingDecoder
//    var codingPath: [CodingKey] { underlyingDecoder.codingPath }
//    var userInfo: [CodingUserInfoKey: Any] { underlyingDecoder.userInfo }
//
//    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
//        try underlyingDecoder.container(keyedBy: type)
//    }
// }
