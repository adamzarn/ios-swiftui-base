//
//  ProfileView.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 1/6/22.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var currentSession: CurrentSession
    @StateObject var authService: AuthService = AuthService()

    var body: some View {
        NavigationView {
            List {
                HStack {
                    Spacer()
                    ProfilePhotoImageView(user: currentSession.user!, size: 120)
                    Spacer()
                }.listRowSeparator(.hidden)
                ProfileItem(key: "Name", value: currentSession.user?.fullName ?? "")
                ProfileItem(key: "Username", value: currentSession.user?.username ?? "")
                ProfileItem(key: "Email", value: currentSession.user?.email ?? "")
                ProfileItem(key: "Created At", value: currentSession.user?.createdAt ?? "")
                ProfileItem(key: "Updated At", value: currentSession.user?.updatedAt ?? "")
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Profile")
            .toolbar(content: {
                LogoutButton(authService: authService).environmentObject(currentSession)
            })
        }
    }
}

struct ProfileItem: View {
    var key: String
    var value: String
    
    var body: some View {
        HStack {
            Text(key.uppercased())
                .font(.caption)
                .fontWeight(.bold)
            Spacer()
            Text(value)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(id: "77155B07-E1A9-46AD-86EF-066544947A33",
                        firstName: "Michael",
                        lastName: "Jordan",
                        username: "Air Jordan",
                        email: "mj@gmail.com",
                        profilePhotoUrl: nil,
                        createdAt: "2021-11-04T00:17:01Z",
                        updatedAt: "2021-11-04T00:17:37Z",
                        isAdmin: false,
                        isEmailVerified: true)
        let currentSession = CurrentSession(defaults: MockUserDefaults(user: user))
        ProfileView().environmentObject(currentSession)
    }
}
