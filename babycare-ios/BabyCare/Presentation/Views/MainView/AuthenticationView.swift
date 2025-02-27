import Foundation
import os
import SwiftUI

public struct AuthenticationView: View {
    @EnvironmentObject private var model: MainViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var loading = false
    @State private var error = false

    public var body: some View {
        VStack(spacing: 32) {
            Text("Tiny Baby Care")
                .font(.largeTitle)
                .foregroundStyle(Color("TextDark"))
            Image("Login")
                .frame(maxWidth: .infinity, alignment: .center)

            Panel {
                VStack(spacing: 16) {
                    HStack {
                        TextField("Email", text: $email)
                            .foregroundStyle(Color("TextDark"))
                            .disabled(loading)
                    }
                    HStack {
                        SecureField("Password", text: $password).disabled(loading)
                            .foregroundStyle(Color("TextDark"))
                    }
                    if loading {
                        Text("Authenticating...")
                            .font(.body)
                            .foregroundStyle(Color("TextDark"))
                    }
                    else {
                        if error {
                            HStack {
                                Image(systemName: "exclamationmark.triangle")
                                Text("Failed to authenticate")
                            }
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundStyle(Color("Red"))
                        }
                        else {
                            Text(" ")
                                .font(.body)
                                .foregroundStyle(Color("TextDark"))
                        }
                    }
                    ActionButton("Login", "rectangle.portrait.and.arrow.right", Color("SleepColor")) {
                        self.error = false
                        self.loading = true

                        model.authenticate(email, password) {
                            self.loading = false
                            self.error = true
                        }
                    }
                }
                .padding(8)
            }
            .padding(.top, 16)
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
    }
}
