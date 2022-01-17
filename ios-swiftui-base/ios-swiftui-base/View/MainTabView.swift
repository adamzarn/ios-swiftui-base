//
//  MainTabView.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 1/6/22.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var currentSession: CurrentSession

    var body: some View {
        TabView {
            FeedView().environmentObject(currentSession).tabItem {
                Label("Feed", systemImage: "list.bullet")
            }
            ProfileView().environmentObject(currentSession).tabItem {
                Label("Profile", systemImage: "person.fill")
            }
        }
    }
}

struct MainTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
