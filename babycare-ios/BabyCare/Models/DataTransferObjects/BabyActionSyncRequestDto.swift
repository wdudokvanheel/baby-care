import Foundation
import os
import SwiftUI

public struct BabyActionSyncRequestDto: Encodable {
    public let from: Int

    init(_ from: Int) {
        self.from = from
    }
}
