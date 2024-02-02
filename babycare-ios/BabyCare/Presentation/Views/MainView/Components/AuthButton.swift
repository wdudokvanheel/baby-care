import SwiftUI

struct AuthButton: View {
    @ObservedObject
    var authService: AuthenticationService


    var body: some View {
        if authService.authenticated {
           
        }
        else {
           
        }
    }
}
