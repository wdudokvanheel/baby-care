import Foundation
import os
import SwiftUI

struct DefaultBabySetting: View {
    private let services: ServiceContainer

    let babies: [Baby]
    @State
    var selected: Baby?
    @State
    var loading = true

    init(babies: [Baby], services: ServiceContainer) {
        self.babies = babies
        self.services = services
    }

    private func getSelectedBaby() {
        Task {
            if let id = services.prefService.getInt(forKey: "baby.default") {
                if let baby = await services.babyService.getByRemoteId(id) {
                    DispatchQueue.main.async {
                        self.selected = baby
                        self.loading = false
                    }
                }
                else {
                    self.loading = false
                }
            }
            else {
                self.loading = false
            }
        }
    }

    var body: some View {
        VStack {
            if !loading {
                Picker("Default baby", selection: $selected) {
                    ForEach(babies, id: \.self) { baby in
                        Text(baby.displayName).tag(baby as Baby?)
                    }
                }
                .pickerStyle(.menu)
                .onChange(of: selected) {
                    if let baby = selected, let id = baby.remoteId {
                        services.prefService.save("\(id)", forKey: "baby.default")
                    }
                }
            }
        }
        .onAppear {
            getSelectedBaby()
        }
    }
}
