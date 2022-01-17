//
//  Session.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 12/21/21.
//

import Foundation

struct Session: Codable {
    let id: UUID
    let token: String
    let requireEmailVerification: Bool
    let user: User
}
