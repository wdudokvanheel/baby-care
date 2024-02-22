import Foundation
import os
import SwiftData
import SwiftUI

public struct SettingsView: View {
    @EnvironmentObject
    var model: MainViewModel

    static var babiesQuery: FetchDescriptor<Baby> {
        let descriptor = FetchDescriptor<Baby>(sortBy: [SortDescriptor(\.birthDate)])
        return descriptor
    }

    @Query(babiesQuery)
    var babies: [Baby]

    init() {}

    public var body: some View {
        VStack {
            Form {
                Section {
                    DefaultBabySetting(babies: babies, services: model.services)
                }
            }

            Spacer()
            HStack {
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
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}
