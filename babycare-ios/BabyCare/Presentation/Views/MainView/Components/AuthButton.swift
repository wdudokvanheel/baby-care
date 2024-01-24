import SwiftUI

struct AuthButton: View {
    @ObservedObject
    var authService: AuthenticationService
    @EnvironmentObject
    var model: MainViewModel

    var body: some View {
        if authService.authenticated {
            Button("Logout") {
                model.logout()
            }
            .font(.footnote)
            .foregroundColor(.white)
        }
        else {
            Button("Login") {
                model.login()
            }
            .font(.footnote)
            .foregroundColor(.white)
        }
    }
}
