import SwiftData
import SwiftUI

public class BabyCareServiceContainer: ObservableObject {
    var container: ModelContainer
    var delegateData: DelegateData
    
    lazy var authService = AuthenticationService()
    lazy var apiService = ApiService(authService)
    lazy var actionService: BabyActionService = .init(container, apiService)
    lazy var syncService: SyncService = .init(apiService, actionService, container)

    init(container: ModelContainer, delegateData: DelegateData) {
        self.container = container
        self.delegateData = delegateData
    }
}
