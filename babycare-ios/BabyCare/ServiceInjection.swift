import SwiftData
import SwiftUI

struct ServiceInjection<Content: View>: View {
    private let content: Content
    private let services: BabyCareServiceContainer

    init(delegate: BabyCareDelegate, @ViewBuilder content: () -> Content) {
        services = .init(container: Self.createModelContainer(), delegateData: delegate.data)
        delegate.setServices(services: services)
        self.content = content()
    }

    private static func createModelContainer() -> ModelContainer {
        do {
            return try ModelContainer(for: Baby.self, BabyAction.self, FeedAction.self)
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
