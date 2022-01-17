//
//  PostsService.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 11/26/21.
//

import Foundation
import SwiftUI

@MainActor
class PostsService: ObservableObject {
    @Published var feed: [Post] = []
    @Published var exception: Exception?
    @Published var didFail: Bool = false
    @Published var isLoading: Bool = true
    
    init() {}
    
    func getFeed() async throws {
        guard let request = Endpoint.getFeed.urlRequest else { return }
        do {
            isLoading = true
            let (data, _) = try await URLSession.shared.data(for: request)
            if let exception = try? JSONDecoder().decode(Exception.self, from: data) {
                handleException(exception)
                return
            }
            feed = try JSONDecoder().decode([Post].self, from: data)
            exception = nil
            didFail = false
            isLoading = false
        } catch {
            handleException(Exception(reason: error.localizedDescription, error: true))
        }
    }
    
    func handleException(_ exception: Exception) {
        self.feed = []
        self.exception = exception
        self.didFail = true
        isLoading = false
    }
}
