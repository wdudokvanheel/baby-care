import SwiftData
import SwiftUI

struct ServiceInjection<Content: View>: View {
    private let content: Content
    private let services: BabyCareServiceContainer

    init(data: DelegateData, @ViewBuilder content: () -> Content) {
        services = .init(container: Self.createModelContainer(), delegateData: data)
        self.content = content()
    }

    private static func createModelContainer() -> ModelContainer {
        do {
            return try ModelContainer(for: BabyAction.self)
        }
        catch {
            print("Data Source Error")
            exit(0)
        }
    }

    var body: some View {
        content
            .modelContext(services.container.mainContext)
            .environmentObject(services)
            .environmentObject(MainViewModel(services))
    }
}
