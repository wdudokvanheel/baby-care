import SwiftUI

public struct Panel<Content: View>: View {
    let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        VStack {
            self.content
        }
        .padding(6)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("BackgroundLight"))
                .shadow(color: Color("ShadowDark").opacity(0.75), radius: 3, x: 3, y: 3)
                .shadow(color: Color("ShadowDark"), radius: 4, x: 5, y: 5)
                .shadow(color: Color("ShadowLight"), radius: 3, x: -3, y: -3)
                .shadow(color: Color("ShadowLight"), radius: 4, x: -5, y: -5)
        )
    }
}
