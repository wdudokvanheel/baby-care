import Foundation
import os
import SwiftData
import SwiftUI

public struct LatestActionsView: View {
    static var latestQuery: FetchDescriptor<BabyAction> {
        var descriptor = FetchDescriptor<BabyAction>(sortBy: [SortDescriptor(\.start, order: .reverse)])
        descriptor.fetchLimit = 100
        return descriptor
    }

    @Query(latestQuery)
    var latest: [BabyAction]

    public var body: some View {
        Text("Items: \(latest.count)")
        VStack {
            ForEach(latest, id: \.self) { action in
                Text("-Action: #\(Int(action.remoteId ?? -1)) \(action.type.rawValue) end: \(action.end != nil ? "YES" : "NO")")
            }
        }
    }
}
