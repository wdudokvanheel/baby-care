import Foundation
import os
import SwiftData
import SwiftUI

public struct LatestActionsView: View {
    private let baby: Baby

    @Query
    var actions: [BabyAction]

    init(baby: Baby) {
        self.baby = baby
        let id = baby.persistentModelID

        self._actions = Query(filter: #Predicate<BabyAction> {
            $0.baby?.persistentModelID == id
        })
    }

    public var body: some View {
        Text("Items for \(baby.name ?? ""): \(actions.count)")
        VStack {
            ForEach(actions, id: \.self) { action in
                Text("-Action: #\(Int(action.remoteId ?? -1)) \(action.type.rawValue) end: \(action.end != nil ? "YES" : "NO")")
            }
        }
    }
}
