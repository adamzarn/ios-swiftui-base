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
    
    init() {}
    
    func getFeed() async throws {
        var request = URLRequest(url: URL(string: "https://vapor-base.herokuapp.com/posts/feed")!)
        request.setValue("Bearer c/QTPzxpnPFQIaxrAHJ5iw==",
                         forHTTPHeaderField: "Authorization")
        request.setValue(UIDevice.current.identifierForVendor?.uuidString,
                         forHTTPHeaderField: "Device-ID")
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            feed = try JSONDecoder().decode([Post].self, from: data)
        } catch {
            print(error.localizedDescription)
        }
    }
}
