import Foundation
import os
import SwiftUI

public struct LoginView: View {
    @EnvironmentObject
    private var model: MainViewModel
    
    @State
    private var email = ""
    @State
    private var password = ""

    public var body: some View {
        VStack {
            HStack {
                Text("Email:")
                TextField("Email", text: $email)
            }
            HStack {
                Text("Password")
                SecureField("Email", text: $password)
            }
            Button("Login"){
                model.authenticate(email, password)
                model.showLogin = false
            }
        }
        .padding()
    }
}
