import SwiftUI

public struct ExpandingButton<Content: View>: View {
    let label: String
    let icon: String
    let color: Color
    let action: () -> Void
    let content: Content

    // Keep a copy of the content, as it might be set to empty when the collapse is triggered, and keeping a cached copy prevents animation glitches
    @State private var frozenContent: Content?

    @Binding var isActive: Bool
    @State var expand: Bool

    @State private var showContent: Bool

    init(
        label: String,
        icon: String,
        color: Color,
        expanded: Binding<Bool>,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.label = label
        self.icon = icon
        self.color = color
        self.action = action
        self.content = content()
        self._isActive = expanded
        self._expand = State(initialValue: expanded.wrappedValue)
        self._showContent = State(initialValue: expanded.wrappedValue)
        self._frozenContent = State(initialValue: expanded.wrappedValue ? self.content : nil)
    }

    public var body: some View {
        VStack {
            if expand {
                (frozenContent ?? content)
                    .padding(8)
                    .opacity(showContent ? 1 : 0)
            } else {
                VStack {
                    HStack(alignment: .center) {
                        Spacer()
                        Image(systemName: icon)
                            .font(.system(size: 18))
                            .foregroundStyle(Color("TextWhite"))

                        Text(label)
                            .foregroundStyle(Color("TextWhite"))
                            .font(.system(size: 18))
                            .fontWeight(.regular)
                            .padding(.vertical, 8)
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    (expand ? Color("BackgroundDark") : self.color)
                        .shadow(expand ?
                            .inner(color: Color("ShadowLight"), radius: 4, x: -5, y: -5) :
                            .inner(color: Color("InnerShadowLight"), radius: 3, x: 3, y: 3)
                        )
                        .shadow(
                            expand ?
                                .inner(color: Color("ShadowDark"), radius: 4, x: 5, y: 5) :
                                .inner(color: Color("InnerShadowDark"), radius: 3, x: -3, y: -3)
                        )
                )

                .shadow(color: Color("ShadowDarker"), radius: expand ? 0 : 4, x: expand ? 0 : 4, y: expand ? 0 : 4)
                .shadow(color: Color("ShadowLight"), radius: expand ? 0 : 3, x: expand ? 0 : -3, y: expand ? 0 : -3)
        )
        .onChange(of: isActive) {
            if isActive {
                self.frozenContent = self.content
                expandToPanel()
            } else {
                collapsePanel()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    self.frozenContent = nil
                }
            }
        }
        .onTapGesture {
            if !self.expand && self.frozenContent == nil {
                self.action()
            }
        }
    }

    public func expandToPanel() {
        self.showContent = false
        withAnimation(.easeIn(duration: 0.3)) {
            self.expand = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeIn(duration: 0.3)) {
                    self.showContent = true
                }
            }
        }
    }

    public func collapsePanel() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            withAnimation(.easeIn(duration: 0.3)) {
                self.expand = false
            }
        }
    }
}
