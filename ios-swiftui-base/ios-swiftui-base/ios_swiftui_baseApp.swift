//
//  ios_swiftui_baseApp.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 11/22/21.
//

import SwiftUI

@main
struct ios_swiftui_baseApp: App {
    @StateObject var currentSession: CurrentSession = CurrentSession()
    
    var body: some Scene {
        WindowGroup {
            if let token = currentSession.token {
                MainTabView()
                    .id(token)
                    .environmentObject(currentSession)
            } else {
                LoginView()
                    .id(UUID())
                    .environmentObject(currentSession)
            }
        }
    }
}
