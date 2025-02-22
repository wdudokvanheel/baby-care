import Foundation
import os
import SwiftUI

public struct MainView2: View {
    public var body: some View {
//        let button = ExpandingButton(
//            label: "Start Sleep",
//            icon: "clock",
//            color: Color("BreastFeedColor"),
//            expanded: false,
//            action: {}
//        ) {
//            VStack {
//                Image(systemName: "clock")
//                Text("Larger")
//                Text("View")
//                    .frame(maxWidth: .infinity)
//                Text("Here")
//                Image(systemName: "clock")
//            }
//            .padding(32)
//        }

        ZStack {
            Color("Background").ignoresSafeArea()

            VStack {
//                button
            }
        }
//        FullscreenPanel {
//            VStack(alignment: .center, spacing: 8) {
//                Text("Lumi's info")
//                    .font(.title)
//                    .fontWeight(.semibold)
//                    .foregroundStyle(Color("TextDark"))
//                    .padding(.top, 0)
        ////                SleepCareView()
//                BreastFeedingCare()
//                Spacer()
//            }
//            .padding(0)
//        }
    }
}

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
            if !self.expand && self.frozenContent == nil{
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

public struct BreastFeedingCare: View {
    public var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Breast Feeding")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("TextDark"))
                    .padding(.top, 0)
                Spacer()
            }
            .padding(0)

            HStack(spacing: 16) {
                InfoTile("Left Breast", "l.square", "00:16", Color("BreastFeedColor"))
                    .frame(maxWidth: .infinity)
                InfoTile("Total", "clock", "00:27", Color("BreastFeedColor"))
                    .frame(maxWidth: .infinity)
                InfoTile("Right Breast", "r.square", "00:11", Color("BreastFeedColor"))
                    .frame(maxWidth: .infinity)
            }
            .padding(0)
            .frame(maxWidth: .infinity)

            ActionButton("Start feeding", "arrowtriangle.right.circle", Color("BreastFeedColor")) {}

            Panel {
                VStack {
                    Spacer()
                    Text("Graph goes here")
                    Spacer()
                }
                .padding(0)
                .frame(maxWidth: .infinity, maxHeight: 200)
            }
            .padding(0)
            Spacer()
        }
        .padding(0)
    }
}

public struct ActionButton: View {
    let label: String
    let icon: String
    let color: Color
    let action: () -> Void

    init(_ label: String, _ icon: String, _ color: Color, _ action: @escaping () -> Void) {
        self.label = label
        self.icon = icon
        self.color = color
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
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
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        color
                            .shadow(.inner(color: Color("InnerShadowLight"), radius: 3, x: 3, y: 3))
                            .shadow(.inner(color: Color("InnerShadowDark"), radius: 3, x: -3, y: -3))
                    )
                    .shadow(color: Color("ShadowDarker"), radius: 4, x: 4, y: 4)
                    .shadow(color: Color("ShadowLight"), radius: 3, x: -3, y: -3)
            )
        }
    }
}

public struct InfoTile: View {
    let text: String
    let icon: String
    let value: String
    let color: Color

    init(_ text: String, _ icon: String, _ value: String, _ color: Color) {
        self.text = text
        self.icon = icon
        self.value = value
        self.color = color
    }

    public var body: some View {
        Panel {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Image(systemName: icon)
                        .foregroundColor(self.color)
                        .font(.title2)
                        .padding(.bottom, 6)

                    Text(text)
                        .foregroundStyle(Color("TextDark"))
                        .font(.caption)
                        .fontWeight(.light)
                    Text(value)
                        .foregroundStyle(self.color)
                        .font(.headline)
                        .fontWeight(.regular)
                }
                .padding(0)
                Spacer()
            }
            .padding(0)
            .padding(.leading, 2)
            .padding(.bottom, 2)
        }
    }
}

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

public struct Well<Content: View>: View {
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
                .fill(
                    Color("BackgroundDark")
                        .shadow(.inner(color: Color("ShadowDark").opacity(0.75), radius: 3, x: 3, y: 3))
                        .shadow(.inner(color: Color("ShadowDark"), radius: 4, x: 5, y: 5))
                        .shadow(.inner(color: Color("ShadowLight"), radius: 3, x: -3, y: -3))
                        .shadow(.inner(color: Color("ShadowLight"), radius: 4, x: -5, y: -5))
                )
        )
    }
}

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
