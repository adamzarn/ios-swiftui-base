//
//  AuthService.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 12/21/21.
//

import Foundation
import SwiftUI

@MainActor
class AuthService: ObservableObject {
    @Published var session: Session?
    @Published var exception: Exception?
    @Published var didFail: Bool = false
    @Published var isLoading: Bool = false
    
    init() {}
    
    func login(_ email: String,
               _ password: String) async throws {
        guard let request = Endpoint.login(email, password).urlRequest else { return }
        do {
            isLoading = true
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let exception = try? JSONDecoder().decode(Exception.self, from: data) {
                handleException(exception)
                return
            }
            session = try JSONDecoder().decode(Session.self, from: data)
            exception = nil
            didFail = false
            isLoading = false
        } catch {
            handleException(Exception(reason: error.localizedDescription, error: true))
        }
    }
    
    func logout() async throws {
        guard let request = Endpoint.logout.urlRequest else { return }
        do {
            isLoading = true
            let (data, _) = try await URLSession.shared.data(for: request)
            if let exception = try? JSONDecoder().decode(Exception.self, from: data) {
                handleException(exception)
                return
            }
            session = nil
            exception = nil
            didFail = false
            isLoading = false
        } catch {
            handleException(Exception(reason: error.localizedDescription, error: true))
        }
    }
    
    func handleException(_ exception: Exception) {
        self.exception = exception
        self.didFail = true
        isLoading = false
    }
}

