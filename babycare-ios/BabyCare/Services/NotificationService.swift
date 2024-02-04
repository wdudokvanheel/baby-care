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
                let update = await actionService.insertOrUpdateAction(dto)

                if let action = update.action {
                    let id = "baby_\(action.baby?.remoteId ?? 0)_\(action.type.rawValue.lowercased())"
                    if update.status == .STARTED {
                        showLocalNotification(id: id, title: "\(action.baby!.displayName) started \(action.type.rawValue.lowercased())", message: "\(action.baby!.displayName) started \(action.type.rawValue.lowercased())")
                    }
                    else if update.status == .ENDED {
                        showLocalNotification(id: id, title: "\(action.baby!.displayName) stopped \(action.type.rawValue.lowercased())", message: "\(action.baby!.displayName) stopped \(action.type.rawValue.lowercased())")
                    }
                }
            }
        }
    }

    func showLocalNotification(id: String, title: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = UNNotificationSound.default

        // Deliver the notification in 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.01, repeats: false)

        // Schedule the notification
        let request = UNNotificationRequest(identifier: "NotificationServiceMessage_", content: content, trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error: Error?) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
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
