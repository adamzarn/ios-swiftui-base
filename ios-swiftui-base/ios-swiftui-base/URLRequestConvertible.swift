//
//  URLRequestConvertible.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 1/6/22.
//

import Foundation

protocol URLRequestConvertible {
    var baseUrl: String { get }
    var path: String? { get }
    var httpMethod: String { get }
    var allHTTPHeaderFields: [String: String] { get }
    var url: URL? { get }
    var urlRequest: URLRequest? { get }
}

extension URLRequestConvertible {
    var url: URL? {
        var urlString = baseUrl
        urlString += path ?? ""
        return URL(string: urlString)
    }
    
    var urlRequest: URLRequest? {
        guard let url = url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        urlRequest.allHTTPHeaderFields = allHTTPHeaderFields
        return urlRequest
    }
}
