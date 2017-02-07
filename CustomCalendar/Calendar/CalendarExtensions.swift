//
//  CalendarExtensions.swift
//  CustomCalendar
//
//  Created by Dimitris C. on 07/02/2017.
//  Copyright © 2017 Decimal. All rights reserved.
//

import Foundation

extension Calendar {
    static let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy MM dd"
        return dateFormatter
    }()
    
    
    func startOfMonth(for date: Date) -> Date? {
        guard let comp = dateFormatterComponents(from: date) else { return nil }
        return Calendar.formatter.date(from: "\(comp.year) \(comp.month) 01")
    }
    
    func endOfMonth(for date: Date) -> Date? {
        guard
            let comp = dateFormatterComponents(from: date),
            let day = self.range(of: .day, in: .month, for: date)?.count else {
                return nil
        }
        
        return Calendar.formatter.date(from: "\(comp.year) \(comp.month) \(day)")
    }
    
    private func dateFormatterComponents(from date: Date) -> (month: Int, year: Int)? {
        
        let comp = self.dateComponents([.year, .month], from: date)
        
        guard
            let month = comp.month,
            let year = comp.year else {
                return nil
        }
        return (month, year)
    }
}

