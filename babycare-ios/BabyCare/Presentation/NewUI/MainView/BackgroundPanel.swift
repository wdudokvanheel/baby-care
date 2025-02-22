import SwiftUI

public struct FullscreenPanel<Content: View>: View {
    let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()

            VStack {
                ScrollView {
                    self.content
                        .padding(.top, 12)
                        .padding(.bottom, 16)
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
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
