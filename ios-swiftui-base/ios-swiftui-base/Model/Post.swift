//
//  Post.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 11/26/21.
//

import Foundation

struct Post: Codable, Identifiable {
    let id: String
    let text: String
    let createdAt: String
    let user: User
}
