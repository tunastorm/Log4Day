//
//  DateFormatManager.swift
//  Log4Day
//
//  Created by 유철원 on 9/22/24.
//

import Foundation

enum DateFormat {
    case dateAndTimeWithTimezone
    case dotSeparatedyyyyMMdd
    case dotSeparatedyyyyMMddHHmm
    case dotSeparatedyyyyMMddDay
    
    var formatString: String {
        return switch self {
        case .dateAndTimeWithTimezone: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        case .dotSeparatedyyyyMMdd:  "yyyy.MM.dd"
        case .dotSeparatedyyyyMMddHHmm: "yyyy.MM.dd HH:mm"
        case .dotSeparatedyyyyMMddDay: "yyyy.MM.dd / EEEEE"
        }
    }
}

protocol DateFormatterProvider {
    
    func stringToFormattedString(value: String, before: DateFormat, after: DateFormat) -> String
    
}


final class DateFormatManager: DateFormatterProvider {
    
    static let shared = DateFormatManager()
    
    private init() {}
    
    private let worker = DateFormatter()

    func dateToFormattedString(date: Date, format: DateFormat) -> String {
        worker.locale = Locale(identifier: "ko_KR")
        worker.dateFormat = format.formatString
        return worker.string(from: date)
    }
    
    func isSameDay(lDate: Date, rDate: Date) -> Bool {
        worker.dateFormat = DateFormat.dotSeparatedyyyyMMdd.formatString
        let ldate = worker.string(from: lDate)
        let rdate = worker.string(from: rDate)
        return ldate == rdate
    }
    
    func stringToFormattedString(value: String, before: DateFormat, after: DateFormat) -> String {
        worker.locale = .current
        worker.dateFormat = before.formatString
        guard let beforeDate = worker.date(from: value) else {
            return ""
        }
        worker.dateFormat = after.formatString
        return worker.string(from: beforeDate)
    }
    
    func nowString() -> String {
        worker.locale = .current
        worker.dateFormat = DateFormat.dateAndTimeWithTimezone.formatString
        let now = worker.string(from: Date())
        return now
    }
    
    func stringToDate(value: String) -> Date? {
        worker.locale = .current
        worker.dateFormat = DateFormat.dateAndTimeWithTimezone.formatString
        return worker.date(from: value)
    }
    
    func dateStringIsNowDate(_ dateString: String) -> Bool {
        worker.locale = .current
        let nowDate = stringToFormattedString(value: nowString(), before: .dateAndTimeWithTimezone, after: .dotSeparatedyyyyMMdd)
        
        let createdDate = stringToFormattedString(value: dateString, before: .dateAndTimeWithTimezone, after: .dotSeparatedyyyyMMdd)
    
        return nowDate == createdDate
    }
    
}



