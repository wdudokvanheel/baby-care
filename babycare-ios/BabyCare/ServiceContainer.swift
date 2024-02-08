import SwiftData
import SwiftUI

public class ServiceContainer: ObservableObject {
    var container: ModelContainer
    var delegateData: DelegateData

    lazy var authService = AuthenticationService()
    lazy var apiService = ApiService(authService, actionMapperService)
    lazy var babyService: BabyService = .init(container, apiService)
    lazy var actionService: BabyActionService = .init(container, apiService, babyService, actionMapperService)
    lazy var syncService: SyncService = .init(self, apiService, babyService, actionService, authService, container)

    lazy var notificationService = NotificationService(delegateData, actionService, apiService, actionMapperService)
    lazy var actionMapperService: ActionMapperService = .init(services: self)

    init(container: ModelContainer, delegateData: DelegateData) {
        self.container = container
        self.delegateData = delegateData
    }
}
