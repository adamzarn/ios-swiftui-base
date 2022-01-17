//
//  CurrentSession.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 12/20/21.
//

import Foundation

extension UserDefaults: Defaults {}

protocol Defaults {
    func string(forKey defaultName: String) -> String?
    func bool(forKey defaultName: String) -> Bool
    func set(_ value: Any?, forKey defaultName: String)
}

class MockUserDefaults: Defaults {
    func string(forKey defaultName: String) -> String? {
        switch defaultName {
        case "userId": return user.id
        case "userFirstName": return user.firstName
        case "userLastName": return user.lastName
        case "userUsername": return user.username
        case "userEmail": return user.email
        case "userProfilePhotoUrl": return user.profilePhotoUrl
        case "userCreatedAt": return user.createdAt
        case "userUpdatedAt": return user.updatedAt
        default: return nil
        }
    }
    
    func bool(forKey defaultName: String) -> Bool {
        switch defaultName {
        case "userIsAdmin": return user.isAdmin
        case "userIsEmailVerified": return user.isEmailVerified
        default: return false
        }
    }
    
    func set(_ value: Any?, forKey defaultName: String) {}
    
    let user: User
    
    init(user: User) {
        self.user = user
    }
}

class CurrentSession: ObservableObject {
    let defaults: Defaults
    
    @Published var token: String? {
        didSet {
            if let token = token {
                Keychain.setString(value: token, forKey: "token")
            } else {
                Keychain.setString(value: "", forKey: "token")
            }
        }
    }
    
    var user: User? {
        get {
            guard let id = defaults.string(forKey: "userId"),
                  let firstName = defaults.string(forKey: "userFirstName"),
                  let lastName = defaults.string(forKey: "userLastName"),
                  let username = defaults.string(forKey: "userUsername"),
                  let email = defaults.string(forKey: "userEmail"),
                  let createdAt = defaults.string(forKey: "userCreatedAt"),
                  let updatedAt = defaults.string(forKey: "userUpdatedAt") else { return nil }
            return User(id: id,
                        firstName: firstName,
                        lastName: lastName,
                        username: username,
                        email: email,
                        profilePhotoUrl: defaults.string(forKey: "userProfilePhotoUrl"),
                        createdAt: createdAt,
                        updatedAt: updatedAt,
                        isAdmin: defaults.bool(forKey: "userIsAdmin"),
                        isEmailVerified: defaults.bool(forKey: "userIsEmailVerified"))
        }
        set {
            let user = newValue
            defaults.set(user?.id, forKey: "userId")
            defaults.set(user?.firstName, forKey: "userFirstName")
            defaults.set(user?.lastName, forKey: "userLastName")
            defaults.set(user?.username, forKey: "userUsername")
            defaults.set(user?.email, forKey: "userEmail")
            defaults.set(user?.profilePhotoUrl, forKey: "userProfilePhotoUrl")
            defaults.set(user?.createdAt, forKey: "userCreatedAt")
            defaults.set(user?.updatedAt, forKey: "userUpdatedAt")
            defaults.set(user?.isAdmin, forKey: "userIsAdmin")
            defaults.set(user?.isEmailVerified, forKey: "userIsEmailVerified")
        }
    }
    
    init(defaults: Defaults = UserDefaults.standard) {
        self.defaults = defaults
        guard let tokenString = Keychain.getString(valueForKey: "token") else {
            self.token = nil
            return
        }
        self.token = tokenString.isEmpty ? nil : tokenString
    }
}
