import SwiftData
import SwiftUI

public struct BabySelector<Content: View>: View {
    static var babiesQuery: FetchDescriptor<Baby> {
        let descriptor = FetchDescriptor<Baby>(sortBy: [SortDescriptor(\.birthDate)])
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
                ScrollView {
                    content(baby)
                        .navigationBarTitleDisplayMode(.inline)
                }
                .padding(0)
            }
            Spacer()
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
        .onChange(of: babies) {
            setDefaultBaby()
        }
        .onAppear {
            setDefaultBaby()
        }
    }
    
    private func setDefaultBaby() {
        if babies.count > 0, selected == nil {
            selected = babies[0]
        }
    }
}
