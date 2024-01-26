import Combine
import Foundation
import SwiftUI

public class NotificationService {
    private var cancellables = Set<AnyCancellable>()

    private let delegateData: DelegateData
    private let actionService: BabyActionService
    private let apiService: ApiService
    private let mappers: ActionMapperService

    init(_ delegateData: DelegateData, _ actionService: BabyActionService, _ apiService: ApiService, _ actionMapperService: ActionMapperService) {
        self.delegateData = delegateData
        self.actionService = actionService
        self.apiService = apiService
        self.mappers = actionMapperService
    }

    public func registerForNotifications() {
        if let id = delegateData.deviceId {
            apiService.performRequest(dto: NotificationRegistrationDto(clientId: id), path: "notifications/register") { _ in
                print("Registed for notifications")
            } onError: {}
        }
    }

    public func onReceivePushData(data: String) {
        guard let data = data.data(using: .utf8) else {
            return
        }
        if let dto = decodeActionDto(from: data) {
            Task {
                await actionService.insertOrUpdateAction(dto)
            }
        }
    }

    private func decodeActionDto(from data: Data) -> ActionDto? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        // Decode JSON to a generic dictionary to read the type
        guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              var type = dictionary["type"] as? String
        else {
            return nil
        }
        type = type.lowercased()

        // Get mapper by type and decode
        let mapper = mappers.getMapper(type: BabyActionType(rawValue: type)!)
        return try? decoder.decode(mapper.getDtoType(), from: data)
    }
}
