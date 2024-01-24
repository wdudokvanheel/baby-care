import Foundation
import os
import SwiftUI

public struct SyncResponseDto<Type: Decodable>: Decodable {
    public let items: [Type]
    public let syncedDate: Int
}
