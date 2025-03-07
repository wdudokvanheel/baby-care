import Foundation
import SwiftUI
import os


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
                        .padding(.bottom, 4)

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
            .padding(.bottom, 0)
        }
    }
}
