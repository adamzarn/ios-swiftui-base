//
//  AuthService.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 12/21/21.
//

import Foundation
import SwiftUI

class AuthService {
    func login(_ email: String,
               _ password: String) async throws -> Session {
        return try await Endpoint.login(email, password).submit(responseType: Session.self)
    }
    
    func logout() async throws {
        return try await Endpoint.logout.submit()
    }
}

