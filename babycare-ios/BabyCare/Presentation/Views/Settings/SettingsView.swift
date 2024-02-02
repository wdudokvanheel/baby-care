import Foundation
import os
import SwiftUI

public struct SettingsView: View {
    @EnvironmentObject
    var model: MainViewModel

    public var body: some View {
        VStack {
            Text("Settings")
            Spacer()
            Button("Logout") {
                model.logout()
            }
            .font(.footnote)
            .foregroundColor(.white)
        }
    }
}
