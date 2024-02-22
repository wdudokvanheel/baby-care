import SwiftData
import SwiftUI

public struct BabySelector: View {
    static var babiesQuery: FetchDescriptor<Baby> {
        let descriptor = FetchDescriptor<Baby>(sortBy: [SortDescriptor(\.birthDate)])
        return descriptor
    }

    @Query(babiesQuery)
    var babies: [Baby]

    @Binding
    public var selected: Baby?

    public var body: some View {
        HStack {
            ForEach(babies, id: \.self) { baby in
                Text("\(baby.displayName)")
                    .onTapGesture {
                        self.selected = baby
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(baby == selected ? .white : .white.opacity(0.5))
            }
        }
    }
}
