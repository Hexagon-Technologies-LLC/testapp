//
//  UserDefaultHandler.swift
//  KMe
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 09/02/2024.
//
import Foundation

extension Date {
    func toString(dateFormat format: String = Defined.commonDateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension String {
    func toDate(dateFormat format: String = Defined.commonDateFormat) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.date(from: self)
    }
    
    func toDateISO8601() -> Date? {
        let newFormatter = ISO8601DateFormatter()
        return newFormatter.date(from: self)
    }
}
