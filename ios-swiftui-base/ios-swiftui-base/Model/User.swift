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
    
    var initials: String {
        let firstInitial = firstName.first
        let lastInitial = lastName.first
        return [firstInitial, lastInitial]
            .compactMap { $0?.uppercased() }
            .map { String($0) }
            .joined()
    }
    
    static var mock: User {
        return User(id: "1",
                    firstName: "Michael",
                    lastName: "Jordan",
                    username: "Air Jordan",
                    email: "mj@gmail.com",
                    profilePhotoUrl: nil,
                    createdAt: "2021-11-04T00:17:01Z",
                    updatedAt: "2021-11-04T00:17:01Z",
                    isAdmin: true,
                    isEmailVerified: true)
    }
}
