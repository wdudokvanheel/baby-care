import Foundation
import SwiftUI

struct MenuPanel<Content: View>: View {
    let height: CGFloat = 80
    let items: [MenuPanelItem]

    @State private var selectedIndex: Int = 0

    let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
        self.items = [
            MenuPanelItem(label: "Baby", view: AnyView(BabyView())),
            MenuPanelItem(label: "Test", view: AnyView(TestView())),
            MenuPanelItem(label: "Settings", view: AnyView(Text("Settings View")))
        ]
    }

    var body: some View {
        VStack {
            GeometryReader { geom in
                ZStack(alignment: .top) {
                    VStack {
                        items[selectedIndex].view
//                        TestView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: max(1, geom.size.height - height))
                    .clipped()

                    VStack {
                        Spacer()
                        VStack {
                            Text("Menu")
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

struct MenuPanelItem {
    let label: String
    let view: AnyView
}

struct TestView: View {
    var body: some View {
        VStack {
            Text("Content 1111")
            Text("Content 1")
            Text("Content 1")
            Text("Content 1")
            Text("Content 1")
            Text("Content 1")
            Text("Content 1")
            Text("Content 1")
            Text("Content 1")
            Text("Content 1")
            Text("Content 1")
            Text("Content 456465465")
            Text("Content 5")
            Text("Content 5")
            Text("Content 1")
            Text("Content 1")
            Text("Content 1")
            Text("Content 1")
            Text("Content 1")
            Text("Content 1")
            Text("Content 1")
            Text("Content 1")
            Text("Content 5")
            Text("Content 5")
            Text("Content 1")
            Text("Content 1")
            Text("Content 1")
            Text("Content 1")
            Text("Content 1")
            Text("Content 1")
            Text("Content 1")
            Text("Content 465465")
            Text("Content 5")
            Text("Content 5")
            Text("Content 1")
            Text("Content 1")
            Text("Content 3")
            Text("Content 1")
            Text("Content 1")
            Text("Content 1")
            Text("Content 1")
            Text("Content 1")
            Text("Content 77777")
                .frame(maxWidth: .infinity)
        }
    }
}
