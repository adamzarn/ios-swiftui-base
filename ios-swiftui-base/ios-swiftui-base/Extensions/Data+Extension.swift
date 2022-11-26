//
//  Data+Extension.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 3/10/22.
//

import Foundation

extension Data {
    var exception: Exception? {
        return try? JSONDecoder().decode(Exception.self, from: self)
    }
    
    func validate() throws {
        if let exception = exception {
            throw ServiceError.server(exception: exception)
        }
    }
    
    func decode<T: Decodable>(_ type: T.Type) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: self)
        } catch {
            throw ServiceError.couldNotDecodeResponse(message: error.localizedDescription)
        }
    }
    
    func validateAndDecode<T: Decodable>(_ type: T.Type) throws -> T {
        try validate()
        return try decode(type)
    }
}
