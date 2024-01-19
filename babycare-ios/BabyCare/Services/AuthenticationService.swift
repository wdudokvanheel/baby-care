import Foundation
import os
import SwiftUI

public class AuthenticationService: ObservableObject {
    @Published
    public var authenticated: Bool = false
    @Published
    public var email: String?
    @Published
    public var token: String?
    
    init(){
        email = "wesley@bitechular.com"
        token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ3ZXNsZXlAYml0ZWNodWxhci5jb20iLCJleHAiOjE3MDkyOTA5MzQsImlhdCI6MTcwNTY5MDkzNH0.9nWyQOCxH9gK_3OSuCMO1lqBfF--kgYVUwn88luKUCtjG5x5vuluYp0Ki8WPmSMaVTJKrBDnPZmz3FULf7OOrg"
    }
}

public struct AuthenticatinonDetails {
    public let email: String
    public let token: String
}
