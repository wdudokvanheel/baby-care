import Foundation
import SwiftUI

struct MenuPanelItem: Identifiable {
    let id = UUID()
    let label: String
    let color: Color
    let type: BabyViewType
}

struct MenuPanel<Content: View>: View {
    let height: CGFloat = 75
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
                            HStack(spacing: 0) {
                                ForEach(items.indices, id: \.self) { index in
                                    Button(action: {
                                        selectedIndex = index
                                    }) {
                                        VStack {
                                            Text(items[index].label)
                                                .foregroundColor(selectedIndex == index ? items[index].color : Color("TextDark"))
                                            Spacer()
                                        }
                                        .padding(.top, 0)
                                        .frame(maxWidth: .infinity)
                                        .frame(maxHeight: .infinity)
                                    }
                                }
                            }
                            .padding(0)
                            Spacer()
                        }
                        .padding(0)
                        .frame(maxWidth: .infinity, maxHeight: height)
                    }
                }
                .padding(0)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}
