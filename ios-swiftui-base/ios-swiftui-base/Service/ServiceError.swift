//
//  ServiceError.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 2/22/22.
//

import Foundation

enum ServiceError: Error {
    case noToken
    case invalidUrlRequest
    case server(exception: Exception)
    case couldNotDecodeResponse(message: String)
}
