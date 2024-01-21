import Foundation
import os
import SwiftUI

public struct BabyActionSyncResponseDto: Decodable {
    public let actions: [BabyActionDto]
    public let syncedDate: Int
}
 
