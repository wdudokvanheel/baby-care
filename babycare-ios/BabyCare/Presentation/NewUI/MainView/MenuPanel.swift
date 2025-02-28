import Foundation
import SwiftUI

struct MenuPanelItem: Identifiable {
    let id = UUID()
    let label: String
    let color: Color
    let type: BabySubView
}

struct MenuPanel<Content: View>: View {
    let height: CGFloat = 80
    @Binding var items: [MenuPanelItem]
    @Binding var selectedIndex: Int

    let content: Content

    public init(items: Binding<[MenuPanelItem]>, selectedIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
        self._items = items
        self._selectedIndex = selectedIndex
        self.content = content()
    }

    var body: some View {
        VStack {
            GeometryReader { geom in
                ZStack(alignment: .top) {
                    VStack {
                        self.content
                    }
                    .frame(maxWidth: .infinity, maxHeight: max(1, geom.size.height - height), alignment: .top)
                    .clipped()

                    VStack {
                        Spacer()
                        VStack {
                            HStack {
                                ForEach(items.indices, id: \.self) { index in
                                    Button(action: {
                                        selectedIndex = index
                                    }) {
                                        Text(items[index].label)
                                            .padding()
                                            .foregroundColor(selectedIndex == index ? items[index].color : Color("TextDark"))
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                            }
                            Spacer()
                        }
                        .padding(0)
                        .frame(maxWidth: .infinity, maxHeight: height)
                        .background(
                            VStack {
                                Rectangle()
                                    .foregroundColor(Color(.white).opacity(0.7))
                                    .frame(height: 1)
                                    .shadow(color: .black, radius: 4, x: 0, y: -2)
                                Spacer()
                            }
                        )
                    }
                }
                .padding(0)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}
