//
//  DateFormatManager.swift
//  Log4Day
//
//  Created by 유철원 on 9/22/24.
//

import Foundation

enum DateFormat {
    case dateAndTime
    case dotSeparatedyyyyMMdd
    case dotSeparatedyyyyMMddHHmm
    case dotSeparatedyyyyMMddDay
    
    var formatString: String {
        return switch self {
        case .dateAndTime: "yyyy-MM-dd HH:mm:ss.SSS"
        case .dotSeparatedyyyyMMdd:  "yyyy.MM.dd"
        case .dotSeparatedyyyyMMddHHmm: "yyyy.MM.dd HH:mm"
        case .dotSeparatedyyyyMMddDay: "yyy.MM.dd/EEEEE"
        }
    }
}

protocol DateFormatterProvider {
    
    func stringToformattedString(value: String, before: DateFormat, after: DateFormat) -> String
    
}


final class DateFormatManager: DateFormatterProvider {
    
    static let shared = DateFormatManager()
    
    private init() {}
    
    private let worker = DateFormatter()

    func stringToformattedString(value: String, before: DateFormat, after: DateFormat) -> String {
        worker.dateFormat = before.formatString
        guard let beforeDate = worker.date(from: value) else {
            return ""
        }
        worker.dateFormat = after.formatString
        return worker.string(from: beforeDate)
    }
    
    func nowString() -> String {
        worker.dateFormat = DateFormat.dateAndTime.formatString
        let now = worker.string(from: Date())
        return now
    }
    
    func stringToDate(value: String) -> Date? {
        worker.dateFormat = DateFormat.dateAndTime.formatString
        return worker.date(from: value)
    }
    
    func dateStringIsNowDate(_ dateString: String) -> Bool {
        let nowDate = stringToformattedString(value: nowString(), before: .dateAndTime, after: .dotSeparatedyyyyMMdd)
        
        let createdDate = stringToformattedString(value: dateString, before: .dateAndTime, after: .dotSeparatedyyyyMMdd)
    
        return nowDate == createdDate
    }
    
}



