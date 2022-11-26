//
//  Endpoint.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 1/6/22.
//

import Foundation
import UIKit

enum Endpoint: URLRequestConvertible {
    case login(_ email: String, _ password: String)
    case logout
    case getFeed
    case uploadProfilePhoto(data: Data)
    
    var baseUrl: String {
        return "https://vapor-base.herokuapp.com"
    }
    
    var path: String? {
        switch self {
        case .login: return "/auth/login"
        case .logout: return "/auth/logout"
        case .getFeed: return "/posts/feed"
        case .uploadProfilePhoto: return "/users/profilePhoto"
        }
    }
    
    var httpMethod: String {
        switch self {
        case .login: return "POST"
        case .logout: return "DELETE"
        case .getFeed: return "GET"
        case .uploadProfilePhoto: return "POST"
        }
    }
    
    var httpBody: Data? {
        switch self {
        case .uploadProfilePhoto(let data): return data
        default: return nil
        }
    }
    
    var allHTTPHeaderFields: [String : String] {
        var headers: [String: String] = [:]
        if let deviceId = UIDevice.current.identifierForVendor?.uuidString {
            headers["Device-ID"] = deviceId
        }
        switch self {
        case .login(let email, let password):
            headers["Authorization"] = getBasicHeaderValue(email, password)
        case .logout, .getFeed, .uploadProfilePhoto:
            headers["Authorization"] = "Bearer \(Keychain.token)"
        }
        return headers
    }
    
    func getBasicHeaderValue(_ email: String,
                             _ password: String) -> String {
        let emailPasswordString = "\(email):\(password)"
        let base64EncodedEmailPasswordString = Data(emailPasswordString.utf8).base64EncodedString()
        return "Basic \(base64EncodedEmailPasswordString)"
    }
}
