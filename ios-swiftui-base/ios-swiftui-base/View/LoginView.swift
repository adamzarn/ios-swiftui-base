//
//  LoginView.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 12/20/21.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var currentSession: CurrentSession
    @State var viewModel = LoginViewModel()
    @StateObject var authService = AuthService()
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Email",
                      text: $viewModel.email,
                      prompt: Text("Email"))
                .padding(.horizontal, 8.0)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            SecureField("Password",
                        text: $viewModel.password,
                        prompt: Text("Password"))
            Button("Login", action: {
                Task {
                    try? await authService.login(viewModel.email, viewModel.password)
                    currentSession.token = authService.session?.token
                    currentSession.user = authService.session?.user
                }
            })
            if authService.isLoading {
                ProgressView()
            }
        }
        .padding()
        .alert(authService.exception?.reason ?? "",
               isPresented: $authService.didFail,
               actions: {})
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
