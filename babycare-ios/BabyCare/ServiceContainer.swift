import SwiftData
import SwiftUI

public class ServiceContainer: ObservableObject {
    var container: ModelContainer
    var delegateData: DelegateData

    lazy var authService = AuthenticationService()
    lazy var actionMapperService = ActionMapperService()
    lazy var apiService = ApiService(authService, actionMapperService)
    lazy var babyService: BabyService = .init(container, apiService)
    lazy var actionService: BabyActionService = .init(container, apiService, babyService, actionMapperService)
    lazy var syncService: SyncService = .init(apiService, babyService, actionService, authService, container)
    lazy var notificationService = NotificationService(delegateData, actionService, apiService, actionMapperService)

    init(container: ModelContainer, delegateData: DelegateData) {
        self.container = container
        self.delegateData = delegateData
    }
}
