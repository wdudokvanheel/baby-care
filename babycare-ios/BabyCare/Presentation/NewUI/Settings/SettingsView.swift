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

    public var body: some View {
        BackgroundView {
            ScrollView {
                VStack {
                    DefaultBabySetting(babies: babies, services: model.services)

                    ForEach(babies, id: \.self) { baby in
                        BabyPanelSettings(baby: baby, prefService: model.services.prefService).tag(baby as Baby)
                    }
                    Spacer()

//                    HStack {
//                        Spacer()
//                        Text(model.services.authService.token ?? "")
//                            .foregroundStyle(.gray.opacity(0.5))
//                            .font(.footnote)
//                    }
//                    Button("Logout") {
//                        model.logout()
//                    }
//                    .font(.footnote)
//                    .foregroundColor(.white)
                }
                .frame(maxHeight: .infinity)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
            }
            .frame(maxHeight: .infinity)
        }
        .navigationTitle("Settings")
//        .navigationBarTitleDisplayMode(.large)
    }
}
