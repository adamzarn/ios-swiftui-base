//
//  LoginViewModel.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 12/20/21.
//

import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    let authService: AuthService
    
    @Published var session: Session?
    @Published var isLoading: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    
    init(authService: AuthService = AuthService()) {
        self.authService = authService
    }
    
    func login() async throws {
        isLoading = true
        session = try await authService.login(email, password)
        isLoading = false
    }
}
