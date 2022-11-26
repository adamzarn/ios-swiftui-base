//
//  PostsService.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 11/26/21.
//

import Foundation
import SwiftUI

class PostsService {
    func getFeed() async throws -> [Post] {
        guard !Keychain.token.isEmpty else { throw ServiceError.noToken }
        return try await Endpoint.getFeed.submit(responseType: [Post].self)
    }
}
