//
//  User.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 11/26/21.
//

import Foundation

struct User: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let username: String
    let email: String
    let profilePhotoUrl: String?
    let createdAt: String
    let updatedAt: String
    let isAdmin: Bool
    let isEmailVerified: Bool
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}
