import Combine
import Foundation
import SwiftUI

public class NotificationService {
    private var cancellables = Set<AnyCancellable>()

    private let delegateData: DelegateData
    private let actionService: BabyActionService
    // TODO: Move these functions out of api service and to a separate serialization service
    private let apiService: ApiService

    init(_ delegateData: DelegateData, _ actionService: BabyActionService, _ apiService: ApiService) {
        self.delegateData = delegateData
        self.actionService = actionService
        self.apiService = apiService
    }

    public func registerForNotifications(){
        if let id = delegateData.deviceId{
            apiService.performRequest(dto: NotifcationRegistrationDto(clientId: id), path: "notifications/register"){ data in
                print("Registed for notifications")
            } onError: {
            
            }
        }
    }
    
    public func onReceivePushData(data: String) {
        if let dto = apiService.parseJson(responseData: data.data(using: .utf8)!) as BabyActionDto? {
            Task {
                await actionService.insertOrUpdateAction(dto)
            }
        }
    }
}
