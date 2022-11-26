//
//  LoginView.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 12/20/21.
//

import SwiftUI

struct LoginView: View, ErrorAlertPresenter {
    @EnvironmentObject var currentSession: CurrentSession
    @StateObject var viewModel = LoginViewModel()
    
    var errorMessageState: State<String?> = State(initialValue: nil)
    var errorIsPresentedState: State<Bool> = State(initialValue: false)
    
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
                .padding(.horizontal, 8.0)
            Button("Login", action: login)
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .padding()
        .alert(isPresented: errorIsPresentedState.projectedValue, content: alert)
    }
    
    func login() {
        Task {
            do {
                try await viewModel.login()
                currentSession.token = viewModel.session?.token
                currentSession.user = viewModel.session?.user
            } catch {
                if let error = error as? ServiceError {
                    switch error {
                    case .server(let exception): setErrorMessage(exception.reason)
                    case .couldNotDecodeResponse(let message): setErrorMessage(message)
                    default: setErrorMessage(nil)
                    }
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
