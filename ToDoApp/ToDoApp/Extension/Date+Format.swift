//
//  Date+Format.swift
//  ToDoApp
//
//  Created by hong on 2023/08/03.
//

import Foundation

extension Date {
    enum formatType: String {
        /// YYYY-MM-dd HH:mm
        case yearMonthDateTime = "YYYY-MM-dd HH:mm"
    }
    
    func formatToString(_ format: formatType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.locale = Locale(identifier: "kor")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        return dateFormatter.string(from: self)
    }
    
    var yearMonthDateTime: String {
        formatToString(.yearMonthDateTime)
    }
}
