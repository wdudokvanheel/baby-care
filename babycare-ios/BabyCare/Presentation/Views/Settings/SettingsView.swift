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
            HStack{
                Spacer()
                Text(model.services.authService.token ?? "")
                    .foregroundStyle(.gray.opacity(0.5))
                    .font(.footnote)
            }
            Button("Logout") {
                model.logout()
            }
            .font(.footnote)
            .foregroundColor(.white)
        }
    }
}
