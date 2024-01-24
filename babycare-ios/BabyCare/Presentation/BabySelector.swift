import SwiftData
import SwiftUI

public struct BabySelector<Content: View>: View {
    static var babiesQuery: FetchDescriptor<Baby> {
        var descriptor = FetchDescriptor<Baby>(sortBy: [SortDescriptor(\.birthDate)])
        return descriptor
    }
    
    @Query(babiesQuery)
    var babies: [Baby]
    
    public var content: (Baby) -> Content
    
    @State
    private var selected: Baby?
    
    public var body: some View {
        VStack {
            if let baby = selected {
                content(baby)
            }
            Spacer()
            HStack {
                ForEach(babies, id: \.self) { baby in
                    Text("\t \(baby.remoteId ?? 0) \(baby.name ?? "Unnamed Baby")")
                        .onTapGesture {
                            self.selected = baby
                        }
                        .foregroundColor(baby == selected ? .blue : .black)
                }
            }
        }
        .onAppear {
            if babies.count > 0 {
                self.selected = babies[0]
            }
        }
    }
}
