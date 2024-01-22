import Foundation
import os
import SwiftUI

public class AuthenticationService: ObservableObject {
    @Published
    private(set) var authenticated: Bool = false
    @Published
    private(set) var email: String?
    @Published
    private(set) var token: String?

    init() {
        do {
            self.email = try KeychainItem(service: "com.bitechular.babycare", account: "email").readItem()
            self.token = try KeychainItem(service: "com.bitechular.babycare", account: "token").readItem()
        }
        catch {
            print("Failed to read keychain: \(error)")
        }
        
        if self.token != nil {
            self.authenticated = true
        }
    }
    
    public func logout() {
        do {
            try KeychainItem(service: "com.bitechular.babycare", account: "email").deleteItem()
            try KeychainItem(service: "com.bitechular.babycare", account: "token").deleteItem()
        }
        catch {
            print("Failed to delete keychain: \(error)")
        }
        self.authenticated = false
    }
    
    public func setAuthDetails(email: String, token: String) {
        self.email = email
        self.token = token
        self.persistDetails()
        if self.token != nil {
            self.authenticated = true
        }
    }
    
    private func persistDetails() {
        do {
            if let email = email {
                try KeychainItem(service: "com.bitechular.babycare", account: "email").saveItem(email)
            }
            
            if let token = token {
                try KeychainItem(service: "com.bitechular.babycare", account: "token").saveItem(token)
            }
        }
        catch {
            print("Failed to persist auth details: \(error)")
        }
    }
}
