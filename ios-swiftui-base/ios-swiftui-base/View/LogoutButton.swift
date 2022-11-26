//
//  LogoutButton.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 1/6/22.
//

import SwiftUI

struct LogoutButton: View {
    @EnvironmentObject var currentSession: CurrentSession
    var authService: AuthService
    
    var body: some View {
        Button(action: {
            Task {
                try? await authService.logout()
                currentSession.token = nil
                currentSession.user = nil
            }
        }, label: {
            Image(systemName: "rectangle.portrait.and.arrow.right")
        })
    }
}
