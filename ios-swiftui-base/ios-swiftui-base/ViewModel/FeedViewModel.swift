//
//  FeedViewModel.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 3/10/22.
//

import SwiftUI

@MainActor
class FeedViewModel: ObservableObject {
    let authService: AuthService
    let postsService: PostsService
    
    @Published var feed: [Post] = []
    @Published var isLoading: Bool = true
    
    init(authService: AuthService = AuthService(),
         postsService: PostsService = PostsService()) {
        self.authService = authService
        self.postsService = postsService
    }
    
    func getFeed() async throws {
        do {
            isLoading = true
            feed = try await postsService.getFeed()
            isLoading = false
        } catch {
            isLoading = false
            throw error
        }
    }
}
