import Foundation
import os
import SwiftUI

public class ApiService {
    private let authService: AuthenticationService
    
    init(_ authService: AuthenticationService) {
        self.authService = authService
    }
    
    public func syncAction(_ action: BabyAction) {
        if action.remoteId == nil || action.remoteId! <= 0 {
            saveAction(action) { id in
                print("Got assigned id #\(id)")
                action.remoteId = id
                action.syncRequired = false
            }
        } else {
            updateAction(action) {
                print("Action updated")
                action.syncRequired = false
            } onError: {
                print("Error during update")
            }
        }
    }
    
    public func updateAction(_ action: BabyAction, onComplete: @escaping () -> Void = {}, onError: @escaping () -> Void = {}) {
        guard let actionId = action.remoteId else {
            onError()
            return
        }
        
        let dto = BabyActionUpdateDto(from: action)
        
        performRequest(dto: dto, path: "action/\(actionId)/", method: "PUT") { data in
            if (self.parseJson(responseData: data) as BabyActionDto?) != nil {
                onComplete()
            }
        } onError: {
            print("Error during request")
            onError()
        }
    }
    
    public func saveAction(_ action: BabyAction, onComplete: @escaping (Int64) -> Void = { _ in }, onError: @escaping () -> Void = {}) {
        let dto = BabyActionCreateDto(from: action)
        
        performRequest(dto: dto, path: "action/") { data in
            if let result: BabyActionDto = (self.parseJson(responseData: data) as BabyActionDto?) {
                onComplete(result.id)
            }
        } onError: {
            print("Error during request")
            onError()
        }
    }

    // TODO: Single callback
    // TODO: Auto decode JSON with generics
    public func performRequest<Dto: Encodable>(dto: Dto, path: String, method: String = "POST", onComplete: @escaping (Data) -> Void = { _ in }, onError: @escaping () -> Void = {}) {
        let url = URL(string: "\(BabyCareApp.API_URL)/\(path)")
        let session = URLSession.shared
        
        let json = toJson(object: dto) ?? ""
        
        print("Performing request: \n\(json)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = authService.token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = json.data(using: .utf8)
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("ApiRequest Failed: No data")
                onError()
                return
            }
            
            print("API response:\n\(String(decoding: data, as: UTF8.self))")

            if let error = error {
                print("Request Failed: \(error.localizedDescription)")
                onError()
            } else {
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        onComplete(data)
                    } else {
                        print("Error status code: \(response.statusCode)")
                        onError()
                    }
                }
            }
        }
        task.resume()
    }
    
    public func authenticate(_ email: String, _ password: String, callback: @escaping () -> Void = {}) {
        let request = AuthenticationRequest(email: email, password: password)
        
        performRequest(dto: request, path: "auth/", method: "POST"){ data in
            if let result: AuthenticationResponse = (self.parseJson(responseData: data) as AuthenticationResponse?) {
                self.authService.setAuthDetails(email: result.email, token: result.token)
                callback()
            }
        }
    }
    
    public func parseJson<ResultType: Decodable>(responseData: Data) -> ResultType? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        do {
            let decodedResponse = try decoder.decode(ResultType.self, from: responseData)
            return decodedResponse
        } catch let DecodingError.dataCorrupted(context) {
            print("Data corrupted: \(context)")
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found: \(context.debugDescription), codingPath: \(context.codingPath)")
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found: \(context.debugDescription), codingPath: \(context.codingPath)")
        } catch let DecodingError.typeMismatch(type, context) {
            print("Type '\(type)' mismatch: \(context.debugDescription), codingPath: \(context.codingPath)")
        } catch {
            print("Other error: \(error.localizedDescription)")
        }
        return nil
    }
    
    private func toJson(object: Encodable) -> String? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        do {
            let jsonData = try jsonEncoder.encode(object)
            return String(data: jsonData, encoding: String.Encoding.utf8)
        } catch {
            return nil
        }
    }
}
