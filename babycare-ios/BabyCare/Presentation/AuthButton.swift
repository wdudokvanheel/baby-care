import SwiftUI

struct AuthButton: View {
    @ObservedObject
    var authService: AuthenticationService
    @EnvironmentObject
    var model: MainViewModel
    
    var body: some View {
        if(authService.authenticated){
            Button("Logout") {
                model.logout()
            }
        }
        else{
            Button("Login") {
                model.login()
            }
        }
    }
}
