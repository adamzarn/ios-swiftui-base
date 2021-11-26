//
//  FeedView.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 11/22/21.
//

import SwiftUI

struct FeedView: View {
    @StateObject var postsService = PostsService()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(postsService.feed, id: \.id) { post in
                    PostListItemView(viewModel: PostListItemViewModel(post: post))
                }
            }
            .listStyle(PlainListStyle())
            .task { try? await postsService.getFeed() }
            .navigationTitle("Feed")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
