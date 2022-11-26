//
//  DateUtility.swift
//  ios-swiftui-base
//
//  Created by Adam Zarn on 2/20/22.
//

import Foundation

struct DateFormat {
    static let iso8601 = "yyyy-MM-dd'T'HH:mm:ssZ"
    static let dateAndTime = "M/d/yy h:mm aa"
}

extension String {
    func formattedDate(from originalDateFormat: String = DateFormat.iso8601,
                       to newDateFormat: String = DateFormat.dateAndTime) -> String? {
        return try? DateUtility.convert(self, from: originalDateFormat, to: newDateFormat)
    }
}

class DateUtility {
    enum ConversionError: Error {
        case invalidOriginalDateFormat
    }
    
    class func convert(_ dateString: String,
                       from originalDateFormat: String = DateFormat.iso8601,
                       to newDateFormat: String = DateFormat.dateAndTime) throws -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = originalDateFormat
        guard let date = dateFormatter.date(from: dateString) else {
            throw ConversionError.invalidOriginalDateFormat
        }
        dateFormatter.dateFormat = newDateFormat
        return dateFormatter.string(from: date)
    }
}
