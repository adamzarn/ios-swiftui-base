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
    var httpBody: Data? { get }
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
        urlRequest.httpBody = httpBody
        urlRequest.allHTTPHeaderFields = allHTTPHeaderFields
        return urlRequest
    }
    
    func submit() async throws {
        return try await data().validate()
    }
    
    func submit<T: Decodable>(responseType: T.Type) async throws -> T {
        return try await data().validateAndDecode(responseType)
    }
    
    func data() async throws -> Data {
        guard let request = urlRequest else { throw ServiceError.invalidUrlRequest }
        return try await URLSession.shared.data(for: request).0
    }
}
