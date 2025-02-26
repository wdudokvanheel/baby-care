import NavigationTransitions
import SwiftUI
import SwiftUIIntrospect

public struct BackgroundView<Content: View>: View {
    let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        ZStack {
            VStack {
                self.content
            }
            .background(
                RoundedRectangle(cornerRadius: 46)
                    .fill(
                        Color("Background")
                            .shadow(
                                .inner(color: Color("BackgroundShadowTop"), radius: 7, x: 8, y: 8)
                            )
                            .shadow(
                                .inner(color: Color("BackgroundShadowBottom"), radius: 5, x: -6, y: -6)
                            )
                    )
                    .ignoresSafeArea()
            )
        }
    }
}
