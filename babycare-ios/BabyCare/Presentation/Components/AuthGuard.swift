import SwiftUI

public struct AuthGuard<Content: View>: View {
    private let content: Content
    @ObservedObject
    private var authService: AuthenticationService

    init(_ authService: AuthenticationService, @ViewBuilder _ content: () -> Content) {
        self.authService = authService
        self.content = content()
    }

    public var body: some View {
        if authService.authenticated {
            content
        }
    }
}

public struct UnAuthGuard<Content: View>: View {
    private let content: Content
    @ObservedObject
    private var authService: AuthenticationService

    init(_ authService: AuthenticationService, @ViewBuilder _ content: () -> Content) {
        self.authService = authService
        self.content = content()
    }

    public var body: some View {
        if !authService.authenticated {
            content
        }
    }
}
