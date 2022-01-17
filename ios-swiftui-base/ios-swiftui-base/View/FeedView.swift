//
//  FeedView.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 11/22/21.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var currentSession: CurrentSession
    @StateObject var postsService = PostsService()
    @StateObject var authService = AuthService()
    
    var body: some View {
        NavigationView {
            FeedContentView(isLoading: postsService.isLoading, feed: postsService.feed)
                .task { try? await postsService.getFeed() }
                .navigationTitle("Feed")
                .toolbar(content: {
                    LogoutButton(authService: authService).environmentObject(currentSession)
                })
                .alert(postsService.exception?.reason ?? "",
                       isPresented: $postsService.didFail,
                       actions: {})
        }
    }
}

struct FeedContentView: View {
    var isLoading: Bool
    var feed: [Post]
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                List {
                    ForEach(feed, id: \.id) { post in
                        PostListItemView(viewModel: PostListItemViewModel(post: post))
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
