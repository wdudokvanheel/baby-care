import SwiftData
import SwiftUI

struct ServiceInjection<Content: View>: View {
    private let container: ModelContainer?
    private let actionService: BabyActionService
    private let authService: AuthenticationService
    private let apiService: ApiService
    private let syncService: SyncService

    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        do {
            container = try ModelContainer(for: BabyAction.self)
        }
        catch {
            print("Data Source Error")
            container = nil
            exit(0)
        }

        let authService = AuthenticationService()
        let apiService = ApiService(authService)
        let actionService = BabyActionService(container!, apiService)
        let syncService = SyncService(apiService, actionService, container!)

        self.authService = authService
        self.apiService = apiService
        self.syncService = syncService
        self.content = content()

        self.actionService = actionService
    }

    var body: some View {
        content
            .modelContext(self.container!.mainContext)
            .environmentObject(MainViewModel(actionService))
    }
}
