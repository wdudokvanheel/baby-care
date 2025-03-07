import SwiftUI

public struct PanelHeader: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.title3)
            .fontWeight(.light)
            .foregroundStyle(Color("TextDark"))
    }
}
