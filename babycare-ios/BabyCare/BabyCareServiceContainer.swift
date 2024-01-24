import SwiftData
import SwiftUI

public class BabyCareServiceContainer: ObservableObject {
    var container: ModelContainer
    var delegateData: DelegateData

    lazy var authService = AuthenticationService()
    lazy var apiService = ApiService(authService)
    lazy var babyService: BabyService = .init(container, apiService)
    lazy var actionService: BabyActionService = .init(container, apiService, babyService)
    lazy var syncService: SyncService = .init(apiService, babyService, actionService, authService, container)
    lazy var notificationService = NotificationService(delegateData, actionService, apiService)

    init(container: ModelContainer, delegateData: DelegateData) {
        self.container = container
        self.delegateData = delegateData
    }
}
