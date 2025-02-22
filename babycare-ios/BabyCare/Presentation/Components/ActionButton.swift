import Foundation
import SwiftUI
import os

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
