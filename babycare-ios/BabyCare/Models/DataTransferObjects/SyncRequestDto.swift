import Foundation
import os
import SwiftUI

public struct SyncRequestDto: Encodable {
    public let from: Int

    init(_ from: Int) {
        self.from = from
    }
}
