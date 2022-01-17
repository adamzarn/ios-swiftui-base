//
//  LogoutButton.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 1/6/22.
//

import SwiftUI

struct LogoutButton: View {
    @EnvironmentObject var currentSession: CurrentSession
    @ObservedObject var authService: AuthService
    
    var body: some View {
        Button("Logout", action: {
            Task {
                try? await authService.logout()
                currentSession.token = nil
                currentSession.user = nil
            }
        })
    }
}
